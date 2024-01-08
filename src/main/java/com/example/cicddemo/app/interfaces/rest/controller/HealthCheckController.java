package com.example.cicddemo.app.interfaces.rest.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class HealthCheckController {

	@GetMapping("/healthcheck")
	public ResponseEntity<String> healthCheck() {
		return ResponseEntity.ok("SUCCESS");
	}

}
