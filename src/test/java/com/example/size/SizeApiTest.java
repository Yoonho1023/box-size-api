package com.example.size;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import com.example.cicddemo.CicdDemoApplication;
import com.example.cicddemo.app.interfaces.rest.dto.SizeRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Transactional
@AutoConfigureMockMvc
@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@ContextConfiguration(classes = CicdDemoApplication.class)
public class SizeApiTest {

	@Autowired
	private MockMvc mockMvc; // mockMvc 생성

	@Test
	@Transactional
	void sizesum_api_호출시_sum한_값을_제대로_return_해야한다() throws Exception {
		SizeRequest request = SizeRequest.builder()
			.height(12)
			.length(12)
			.width(12)
			.build();

		String payload = this.asJsonString(request);

		mockMvc.perform(post("/size-sum").contentType(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).content(payload))
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.result.size", is(36)));

	}

	@Test
	@Transactional
	void size_api_호출시_알맞은_grade_값을_return_해야한다() throws Exception {
		SizeRequest request = SizeRequest.builder()
			.height(12)
			.length(12)
			.width(12)
			.build();

		String payload = this.asJsonString(request);

		mockMvc.perform(post("/size").contentType(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).content(payload))
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.result.grade", is("A")));

	}

	@Test
	@Transactional
	void sizesum_api_호출시_sum한_값을_제대로_return_해야하고_이것에_해당하는_등급을_잘_가져와야한다() throws Exception {
		SizeRequest request = SizeRequest.builder()
			.height(10)
			.length(10)
			.width(10)
			.build();

		String payload = this.asJsonString(request);

		mockMvc.perform(post("/size-sum").contentType(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).content(payload))
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.result.size", is(30)));

		mockMvc.perform(post("/size").contentType(MediaType.APPLICATION_JSON).accept(MediaType.APPLICATION_JSON).content(payload))
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.result.grade", is("B")));
	}

	private String asJsonString(final Object obj) {
		try {
			return new ObjectMapper().writeValueAsString(obj);
		} catch (JsonProcessingException e) {
			throw new RuntimeException(e);
		}
	}

}
