package com.example.cicddemo.app.service;

import org.springframework.stereotype.Service;

import com.example.cicddemo.app.interfaces.rest.dto.SizeRequest;
import com.example.cicddemo.app.interfaces.rest.dto.SizeResponse;

@Service
public class SizeService {

	public SizeResponse getSize(SizeRequest request) {
		String size;
		int sum = request.getHeight() + request.getWidth() + request.getLength();

		if (sum >= 35) {
			size = "A";
		} else {
			size = "B";
		}

		SizeResponse.Result result = SizeResponse.Result.builder().grade(size).build();

		return SizeResponse.builder().result(result).build();
	}

	public SizeResponse sumSize(SizeRequest request) {
		int sum = request.getHeight() + request.getWidth() + request.getLength();

		SizeResponse.Result result = SizeResponse.Result.builder().size(sum).build();

		return SizeResponse.builder()
			.result(result)
			.build();
	}
}
