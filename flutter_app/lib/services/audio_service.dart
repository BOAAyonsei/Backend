import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class AudioService {
  // 데모용 가상 녹음 상태
  bool _isRecording = false;

  // Python 백엔드 서버 주소
  static const String _baseUrl = 'http://172.20.10.7:5001';

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
      print('녹음 중지 및 분석 시작');
      _isRecording = false;

      // 서버에 실제 분석 요청
      return await _analyzeAudioFile();
    } catch (e) {
      print('서버 분석 실패, 테스트 모드 실행: $e');
      // 서버 분석 실패 시 더미 결과 반환
      return _getDummyResult();
    }
  }

  Future<Map<String, dynamic>> _analyzeAudioFile() async {
    try {
      // 1. 애셋에서 가상 오디오 파일 로드
      final byteData = await rootBundle.load('assets/virtual_recording.wav');
      final buffer = byteData.buffer.asUint8List();

      // 2. Multipart 요청 생성
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/analyze_audio'),
      );

      // 3. 파일을 요청에 추가
      request.files.add(http.MultipartFile.fromBytes(
        'audio', // 백엔드에서 받을 파일 필드 이름
        buffer,
        filename: 'virtual_recording.wav',
      ));

      print('서버로 오디오 파일 전송 시작...');

      // 4. 요청 전송 및 응답 수신
      final streamedResponse = await request.send().timeout(const Duration(seconds: 10));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('서버 분석 성공');
        final result = json.decode(response.body);
        print('분석 결과: $result');
        return result as Map<String, dynamic>;
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode} ${response.body}');
      }
    } on FileSystemException catch (e) {
      throw Exception('오디오 파일을 찾을 수 없습니다. assets/virtual_recording.wav 파일이 있는지 확인하세요. 오류: $e');
    }
    catch (e) {
      throw Exception('오디오 분석 중 오류 발생: $e');
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
