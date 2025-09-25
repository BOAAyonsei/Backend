package com.safevoice.controller;

import com.safevoice.service.AudioAnalysisService;
import com.safevoice.service.EmergencyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@RestController
@RequestMapping("/api/audio")
@CrossOrigin(origins = "*")
public class AudioController {

    @Autowired
    private AudioAnalysisService audioAnalysisService;

    @Autowired
    private EmergencyService emergencyService;

    @PostMapping("/analyze")
    public ResponseEntity<?> analyzeAudio(@RequestParam("audio") MultipartFile audioFile) {
        try {
            Map<String, Object> result = audioAnalysisService.analyzeAudio(audioFile);

            boolean isScream = (Boolean) result.get("is_scream");
            if (isScream) {
                // 비명이 감지되면 긴급 알림 처리
                emergencyService.sendEmergencyAlert(result);
            }

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("error", "Audio analysis failed: " + e.getMessage()));
        }
    }

    @GetMapping("/health")
    public ResponseEntity<?> healthCheck() {
        return ResponseEntity.ok(Map.of(
            "status", "healthy",
            "service", "Safe Voice Backend"
        ));
    }
}