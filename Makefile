ecr := "318133470688.dkr.ecr.ap-northeast-2.amazonaws.com/ecr-tm-be"
ecr-feature := "318133470688.dkr.ecr.ap-northeast-2.amazonaws.com/ecr-tm-be-feature"
qaBucket := "bucket-tm-backend-ci"
repoName := "hanjin-tm-application-codebase"

.PHONY: init
init:
	@echo "HANJIN-TM-Application-Codebase Initialize"
	@echo "mysql & redis docker up"
	@docker-compose -p trucking -f src/main/resources/db/container/database/docker-compose.yaml up -d

.PHONY: gen
gen:
	@./gradlew compileJava

.PHONY: clean
	@./gradlew clean

.PHONY: compile
compile:
	@./gradlew compileJava

.PHONY: run
run: compile
	@./gradlew bootRun

clean:
	@./gradlew clean

.PHONY: test
test:
	@./gradlew test

build.application:
	@./gradlew build -x test

build.docker: build.application
	@docker build -t hanjin-tm:latest .

.PHONY: build
build: build.docker

.PHONY: docker-run
docker-run:
ifeq ($(b), false)
	@echo "Run hanjin-tm without build"
	@docker run -p 8082:8080 -e SPRING_PROFILES_ACTIVE=local-docker --network trucking_default --rm --name trucking-server hanjin-tm:latest
else
	@echo "Docker build before run hanjin-tm"
	@./gradlew clean build -x test
	@docker build -t hanjin-tm:latest .
	@docker run -p 8082:8080 -e SPRING_PROFILES_ACTIVE=local-docker --network trucking_default --rm --name trucking-server hanjin-tm:latest
endif

push-dev: guard-tag
	@echo "Docker build & direct-push to ${ecr} (DEV)"
	@./gradlew clean build -x test
	@docker build --platform=linux/amd64 -t hanjin-tm:latest .
	docker tag hanjin-tm:latest 318133470688.dkr.ecr.ap-northeast-2.amazonaws.com/ecr-tm-be:${tag}
	docker push 318133470688.dkr.ecr.ap-northeast-2.amazonaws.com/ecr-tm-be:${tag}

.PHONY: release
release: guard-v
ifeq (${v} , latest)
	@echo "###### Release latest version to Production"
	@git checkout -t origin/release && git switch main && git branch -D release && git switch -c release
	@echo "####### Searching for SQL update -> $(or $(shell git diff HEAD $(shell git rev-parse --short=7 origin/release) --name-only | grep "\.sql"), No SQL update founded)"
	@git push origin release -f && git switch main && git branch -D release
else
	@echo "###### Release $(v) Version to Production"
	@git checkout -t origin/release && git switch main && git branch -D release
	@git switch -c release $(or $(shell git rev-parse --short=7 $(v)), $(error COMMIT_ID: ${v} is not correct))
	@echo "###### Searching for SQL update -> $(or $(shell git diff HEAD $(shell git rev-parse --short=7 origin/release) --name-only | grep "\.sql"), No SQL update founded)"
	@git push origin release -f && git switch main && git branch -D release
endif

.PHONY: feature
feature: guard-location
	@echo "Deploy Application to feature${location} Environment"
	@./gradlew clean build -x test
	@docker build --build-arg SPRING_PROFILES_ACTIVE=feature${location} --build-arg FEATURE_DB=feature${location} -t ${ecr-feature}:latest .
	@docker tag ${ecr-feature}:latest ${ecr-feature}:$(shell git rev-parse --short=7 HEAD)
	@aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${ecr-feature}
	@docker push ${ecr-feature}:$(shell git rev-parse --short=7 HEAD)
	@export REPOSITORY_URI=${ecr-feature} && export IMAGE_TAG=$(shell git rev-parse --short=7 HEAD) && cat ./build_scripts/imageDef.json | envsubst > ./imagedefinitions.json
	@zip -r feature${location}.zip imagedefinitions.json
	@aws s3 cp ./feature${location}.zip s3://${qaBucket}/deployment/${repoName}/feature${location}.zip --metadata '{"commit-id":"$(shell git rev-parse --short=7 HEAD)"}'
	@rm -rf imagedefinitions.json feature${location}.zip


.PHONY: qa
qa: guard-v
	@echo "Deploy $(v) Version to QA Environment"
	@export REPOSITORY_URI=${ecr} && export IMAGE_TAG=$(shell git rev-parse --short=7 $(v)) && cat ./build_scripts/imageDef.json | envsubst > ./imagedefinitions.json
	@zip -r qa.zip imagedefinitions.json
	@aws s3 cp ./qa.zip s3://${qaBucket}/deployment/${repoName}/qa.zip --metadata '{"commit-id":"$(shell git rev-parse --short=7 $(v))"}'
	@rm -rf imagedefinitions.json qa.zip

.PHONY: guard-%
guard-%:
	@#$(or ${$*}, $(error $* is not set))
