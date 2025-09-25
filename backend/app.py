from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import librosa
import io
import tempfile
import os
from model import ScreamDetector

app = Flask(__name__)
CORS(app)

# 모델 초기화
MODEL_PATH = "../AI_recording/cnn_transformer_model.pth"
scream_detector = ScreamDetector(MODEL_PATH)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'message': 'Safe Voice API is running'})

@app.route('/analyze_audio', methods=['POST'])
def analyze_audio():
    try:
        if 'audio' not in request.files:
            return jsonify({'error': 'No audio file provided'}), 400

        audio_file = request.files['audio']

        # 임시 파일로 저장
        with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as tmp_file:
            audio_file.save(tmp_file.name)

            # librosa로 오디오 로드
            audio_data, sample_rate = librosa.load(tmp_file.name, sr=22050)

            # 임시 파일 삭제
            os.unlink(tmp_file.name)

        # 비명 감지 예측
        is_scream, confidence = scream_detector.predict(audio_data, sample_rate)

        result = {
            'is_scream': is_scream,
            'confidence': float(confidence),
            'message': 'Scream detected!' if is_scream else 'No scream detected',
            'audio_length': len(audio_data) / sample_rate
        }

        return jsonify(result)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/emergency_alert', methods=['POST'])
def emergency_alert():
    """
    비명이 감지되었을 때 호출되는 긴급 알림 API
    """
    try:
        data = request.get_json()
        location = data.get('location', 'Unknown')
        timestamp = data.get('timestamp', 'Unknown')
        confidence = data.get('confidence', 0.0)

        # 여기서 실제로는 경찰서나 보안업체에 알림을 보내는 로직 구현
        # 현재는 로그만 출력
        alert_message = f"🚨 EMERGENCY ALERT 🚨\n"
        alert_message += f"Scream detected at: {location}\n"
        alert_message += f"Time: {timestamp}\n"
        alert_message += f"Confidence: {confidence:.2%}\n"

        print(alert_message)

        # 응답 반환
        response = {
            'alert_sent': True,
            'message': 'Emergency services have been notified',
            'location': location,
            'timestamp': timestamp
        }

        return jsonify(response)

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    print("Starting Safe Voice API server...")
    print(f"Model path: {MODEL_PATH}")
    app.run(host='0.0.0.0', port=5000, debug=True)