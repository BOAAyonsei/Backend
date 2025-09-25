package com.safevoice.service;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Service
public class AudioAnalysisService {

    private final RestTemplate restTemplate;
    private final String PYTHON_API_URL = "http://localhost:5000";

    public AudioAnalysisService() {
        this.restTemplate = new RestTemplate();
    }

    public Map<String, Object> analyzeAudio(MultipartFile audioFile) throws IOException {
        // Python API로 오디오 파일 전송
        String url = PYTHON_API_URL + "/analyze_audio";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);

        // 파일을 ByteArrayResource로 변환
        ByteArrayResource fileResource = new ByteArrayResource(audioFile.getBytes()) {
            @Override
            public String getFilename() {
                return audioFile.getOriginalFilename();
            }
        };

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("audio", fileResource);

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<Map> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                requestEntity,
                Map.class
            );

            return response.getBody();
        } catch (Exception e) {
            throw new RuntimeException("Failed to analyze audio: " + e.getMessage());
        }
    }
}