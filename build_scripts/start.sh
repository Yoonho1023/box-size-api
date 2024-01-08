#!/bin/bash

BUILD_ARTIFACT_VERSION=$(ls /opt/codedeploy-agent/deployment-root/5665c9db-e8a9-465a-a266-54b9441fd282/ -tr | tail -1)
BUILD_JAR_PATH=$(ls /opt/codedeploy-agent/deployment-root/5665c9db-e8a9-465a-a266-54b9441fd282/$BUILD_ARTIFACT_VERSION/deployment-archive/*.jar)
JAR_NAME=$(basename $BUILD_JAR_PATH)

echo "> BUILD_ARTIFACT_VERSION: $BUILD_ARTIFACT_VERSION" >> /home/ec2-user/deploy.log
echo "> BUILD_JAR_PATH: $BUILD_JAR_PATH" >> /home/ec2-user/deploy.log
echo "> JAR_NAME: $JAR_NAME" >> /home/ec2-user/deploy.log
#BASE_PATH = /home/ec2-user/deploy/
#echo "> BASE_PATH: $BASE_PATH" >> /home/ec2-user/deploy.log
#
#DEPLOY_PATH = $BASE_PATH$BUILD_ARTIFACT_VERSION
#
#echo "> DEPLOY_PATH: $DEPLOY_PATH" >> /home/ec2-user/deploy.log
#
#echo "> build 파일명: $JAR_NAME" >> /home/ec2-user/deploy.log
#
#echo "> build 파일 복사 준비: $BUILD_JAR_PATH to $DEPLOY_PATH" >> /home/ec2-user/deploy.log
#
#mkdir -p $DEPLOY_PATH
#
#echo "> build 파일 복사" >> /home/ec2-user/deploy.log
#cp $BUILD_JAR_PATH $DEPLOY_PATH

echo "> 현재 실행중인 애플리케이션 pid 확인" >> /home/ec2-user/deploy.log

CURRENT_PID=$(pgrep -f $JAR_NAME)

echo "> OLD_PID: $CURRENT_PID" >> /home/ec2-user/deploy.log

if [ -z $CURRENT_PID ]
then
  echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다." >> /home/ec2-user/deploy.log
else
  echo "> kill -15 $CURRENT_PID"
  kill -9 $CURRENT_PID
  sleep 5
fi

#DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME

echo "> deploy jar 파일 명: $DEPLOY_JAR" >> /home/ec2-user/deploy.log

echo "> DEPLOY_JAR 배포"    >> /home/ec2-user/deploy.log
nohup java -jar $BUILD_JAR_PATH logging.file.path=/home/ec2-user/ --logging.level.org.hibernate.SQL=DEBUG >> /home/ec2-user/deploy.log 2>/home/ec2-user/deploy_err.log &
sleep 15

NEW_PID=$(pgrep -f $JAR_NAME)

echo "> NEW_PID: $NEW_PID" >> /home/ec2-user/deploy.log

echo "> DEPLOY_JAR 배포 완료"    >> /home/ec2-user/deploy.log