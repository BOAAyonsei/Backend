package com.safevoice.service;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

@Service
public class EmergencyService {

    private final RestTemplate restTemplate;
    private final String PYTHON_API_URL = "http://localhost:5000";

    public EmergencyService() {
        this.restTemplate = new RestTemplate();
    }

    public void sendEmergencyAlert(Map<String, Object> analysisResult) {
        try {
            // 긴급 상황 정보 준비
            Map<String, Object> emergencyData = new HashMap<>();
            emergencyData.put("location", "Unknown Location"); // GPS 정보가 있다면 여기에 추가
            emergencyData.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            emergencyData.put("confidence", analysisResult.get("confidence"));
            emergencyData.put("audio_length", analysisResult.get("audio_length"));

            // Python API로 긴급 알림 전송
            String url = PYTHON_API_URL + "/emergency_alert";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(emergencyData, headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                requestEntity,
                Map.class
            );

            System.out.println("Emergency alert sent successfully: " + response.getBody());

            // 여기서 추가적인 긴급 처리 로직 구현
            // - SMS 발송
            // - 이메일 알림
            // - 실제 경찰서/보안업체 연동
            sendPoliceAlert(emergencyData);

        } catch (Exception e) {
            System.err.println("Failed to send emergency alert: " + e.getMessage());
        }
    }

    private void sendPoliceAlert(Map<String, Object> emergencyData) {
        // 실제 구현에서는 경찰서 API나 보안업체와 연동
        System.out.println("🚨🚨 POLICE ALERT 🚨🚨");
        System.out.println("Emergency detected and reported!");
        System.out.println("Location: " + emergencyData.get("location"));
        System.out.println("Time: " + emergencyData.get("timestamp"));
        System.out.println("Confidence: " + String.format("%.2f%%", ((Double) emergencyData.get("confidence")) * 100));

        // 여기서 실제 112 신고 시스템이나 보안업체 API 호출
        // 예: 경찰청 신고 API, 보안업체 연동 등
    }
}