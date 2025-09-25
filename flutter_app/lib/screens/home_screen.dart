import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/audio_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioService _audioService = AudioService();
  bool _isRecording = false;
  bool _isAnalyzing = false;
  String _status = '안전 모니터링 준비됨';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 헤더
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.security_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Safe Voice',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '여성 안심 귀갓길',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 상태 표시
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getStatusColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '현재 상태',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _status,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        '현재 위치: 서울특별시 강남구',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // 메인 버튼
                if (_isAnalyzing)
                  Column(
                    children: [
                      const SpinKitWave(
                        color: Colors.pink,
                        size: 50.0,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '음성 분석 중...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  )
                else
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _isRecording
                            ? [Colors.red, Colors.redAccent]
                            : [const Color(0xFFE91E63), const Color(0xFFAD1457)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording ? Colors.red : Colors.pink).withOpacity(0.4),
                            spreadRadius: 10,
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                Text(
                  _isRecording ? '녹음 중지하기' : '음성 모니터링 시작',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // 안내 텍스트
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 24,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '사용 방법',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '• 위험을 느끼는 골목길에서 버튼을 눌러주세요\n'
                        '• 5초간 주변 소리를 모니터링합니다\n'
                        '• 비명 소리가 감지되면 자동으로 신고됩니다\n'
                        '• GPS 위치와 함께 긴급 알림이 전송됩니다',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (_isRecording) return Colors.red;
    if (_isAnalyzing) return Colors.orange;
    if (_status.contains('위험 상황 감지')) return Colors.red;
    if (_status.contains('정상')) return Colors.green;
    return Colors.blue;
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
      _status = '음성 모니터링 중...';
    });

    try {
      await _audioService.startRecording();

      // 5초간 녹음
      await Future.delayed(const Duration(seconds: 5));

      if (_isRecording) {
        await _stopRecording();
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _status = '녹음 실패: $e';
      });
    }
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;
      _isAnalyzing = true;
      _status = '음성 분석 중...';
    });

    try {
      final result = await _audioService.stopRecordingAndAnalyze();

      setState(() {
        _isAnalyzing = false;
        if (result['is_scream'] == true) {
          _status = '🚨 위험 상황 감지! 긴급 신고됨';
        } else {
          _status = '✅ 정상 - 위험 상황 없음';
        }
      });

      if (result['is_scream'] == true) {
        _showEmergencyAlert();
      }

      // 3초 후 상태 초기화
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _status = '안전 모니터링 준비됨';
        });
      }

    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _status = '분석 실패: $e';
      });

      // 3초 후 상태 초기화
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _status = '안전 모니터링 준비됨';
        });
      }
    }
  }

  void _showEmergencyAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text(
              '긴급 상황 감지',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          '비명 소리가 감지되었습니다.\n\n✓ 긴급 신고가 전송되었습니다\n✓ 현재 위치가 공유되었습니다\n✓ 경찰서에 알림이 전달되었습니다',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text('확인'),
            ),
          ),
        ],
      ),
    );
  }
}