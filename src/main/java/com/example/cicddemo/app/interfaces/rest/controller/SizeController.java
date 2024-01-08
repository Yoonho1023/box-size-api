package com.example.cicddemo.app.interfaces.rest.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.cicddemo.app.interfaces.rest.dto.SizeRequest;
import com.example.cicddemo.app.interfaces.rest.dto.SizeResponse;
import com.example.cicddemo.app.service.SizeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class SizeController {

	private final SizeService sizeService;

	@PostMapping("/size")
	public SizeResponse size(@RequestBody SizeRequest request) {
		return sizeService.getSize(request);
	}

	@PostMapping("/size-sum")
	@ResponseBody
	public SizeResponse sizeSum(@RequestBody SizeRequest request) {
		return sizeService.sumSize(request);
	}

	@GetMapping("/dimensions")
	@ResponseBody
	public String dimensions() {
		return "CM";
	}

}
