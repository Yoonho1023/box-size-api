package com.example.cicddemo.app.interfaces.rest.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class SizeRequest {

	@JsonProperty("height")
	public int height;

	@JsonProperty("width")
	public int width;

	@JsonProperty("length")
	public int length;
}
