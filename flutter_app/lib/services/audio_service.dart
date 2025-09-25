import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class AudioService {
  // 데모용 가상 녹음 상태
  bool _isRecording = false;

  // Spring Boot 백엔드 서버 주소
  static const String _baseUrl = 'http://localhost:8080/api/audio';

  Future<void> startRecording() async {
    try {
      print('녹음 시작 (데모 모드)');
      _isRecording = true;

      // 실제 마이크 권한 확인 없이 데모 진행
      await Future.delayed(const Duration(milliseconds: 500));

      print('가상 녹음 시작됨');
    } catch (e) {
      print('녹음 시작 오류: $e');
      throw Exception('녹음 시작 실패: $e');
    }
  }

  Future<Map<String, dynamic>> stopRecordingAndAnalyze() async {
    try {
      print('녹음 중지 (데모 모드)');
      _isRecording = false;

      // 가상 분석 시간
      await Future.delayed(const Duration(milliseconds: 1000));

      // 서버 연결 시도 (실패하면 더미 결과)
      try {
        return await _tryServerAnalysis();
      } catch (e) {
        print('서버 연결 실패, 테스트 모드 실행: $e');
        return _getDummyResult();
      }
    } catch (e) {
      print('분석 실패, 테스트 모드 실행: $e');
      return _getDummyResult();
    }
  }

  Future<Map<String, dynamic>> _tryServerAnalysis() async {
    // 서버 상태 확인
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        print('서버 연결 성공, 실제 분석 진행');
        // 실제 서버가 있다면 여기서 분석 진행
        return _getDummyResult(); // 현재는 더미 결과 반환
      } else {
        throw Exception('서버 응답 오류');
      }
    } catch (e) {
      throw Exception('서버 연결 실패: $e');
    }
  }

  Map<String, dynamic> _getDummyResult() {
    // 테스트용 더미 결과 (데모용)
    final random = Random();
    final randomValue = random.nextInt(10);
    final isScream = randomValue < 3; // 30% 확률로 비명 감지

    print('테스트 모드 결과: ${isScream ? "비명 감지" : "정상"} (랜덤값: $randomValue)');

    return {
      'is_scream': isScream,
      'confidence': isScream ? (0.8 + random.nextDouble() * 0.15) : (0.1 + random.nextDouble() * 0.3),
      'message': isScream ? 'Scream detected!' : 'No scream detected',
      'audio_length': 5.0,
    };
  }

  Future<bool> hasPermission() async {
    // 데모용으로 항상 true 반환
    return true;
  }

  void dispose() {
    _isRecording = false;
  }
}