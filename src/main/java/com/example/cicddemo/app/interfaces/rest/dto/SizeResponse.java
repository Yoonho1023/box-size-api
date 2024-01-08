package com.example.cicddemo.app.interfaces.rest.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Getter;

@Builder
public class SizeResponse {

	@JsonProperty("result")
	private Result result;

	@Builder
	public static class Result {

		@JsonProperty("size")
		private int size;

		@JsonProperty("grade")
		private String grade;
	}
}
