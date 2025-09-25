# Safe Voice - 여성 안심 귀갓길 비명 감지 앱

## 프로젝트 개요

Safe Voice는 여성들의 안전한 귀가를 지원하기 위한 AI 기반 비명 감지 시스템입니다. 음성 인식 기술과 CNN 모델을 활용하여 실시간으로 비상 상황을 감지하고 자동으로 신고하는 기능을 제공합니다.

## 시스템 구조

```
Safe_Voice/
├── AI_recording/              # 학습된 CNN 모델
│   ├── CNN_Transformer.py    # CNN + Transformer 모델
│   └── cnn_transformer_model.pth  # 학습된 모델 가중치
├── backend/                   # Python Flask API 서버
│   ├── app.py                # Flask 메인 앱
│   ├── model.py              # CNN 모델 로더
│   └── requirements.txt      # Python 의존성
├── spring_backend/           # Spring Boot API 서버
│   └── src/main/java/com/safevoice/
│       ├── controller/       # REST API 컨트롤러
│       └── service/          # 비즈니스 로직
└── flutter_app/             # Flutter 모바일 앱
    └── lib/
        ├── screens/          # UI 화면
        └── services/         # API 통신 서비스
```

## 주요 기능

### 1. 실시간 음성 모니터링
- 마이크를 통한 실시간 음성 감지
- 5초 간격으로 자동 녹음 및 분석

### 2. AI 기반 비명 감지
- CNN + Transformer 모델을 사용한 정확한 비명 소리 감지
- 일반 소음과 비명 소리 구별

### 3. 자동 긴급 신고
- 비명 감지 시 자동으로 경찰서 신고
- GPS 위치 정보와 함께 전송

### 4. 사용자 친화적 인터페이스
- 간단한 원터치 모니터링 시작
- 실시간 상태 표시

## 설치 및 실행

### 1. Python 환경 설정
```bash
cd backend
pip install -r requirements.txt
python app.py
```

### 2. Spring Boot 서버 실행
```bash
cd spring_backend
mvn spring-boot:run
```

### 3. Flutter 앱 실행
```bash
cd flutter_app
flutter pub get
flutter run
```

### 4. 한번에 서버 실행 (Windows)
```bash
start_servers.bat
```

## API 엔드포인트

### Python Flask Server (Port 5000)
- `GET /health` - 서버 상태 확인
- `POST /analyze_audio` - 오디오 분석
- `POST /emergency_alert` - 긴급 알림

### Spring Boot Server (Port 8080)
- `GET /api/audio/health` - 서버 상태 확인
- `POST /api/audio/analyze` - 오디오 분석 (Flutter에서 호출)

## 기술 스택

- **AI/ML**: PyTorch, CNN + Transformer, librosa
- **Backend**: Python Flask, Spring Boot (Java)
- **Frontend**: Flutter/Dart
- **Database**: H2 (임시), 추후 PostgreSQL 연동 가능
- **기타**: REST API, 음성 처리, GPS 위치 서비스

## 해커톤 데모 시나리오

1. **앱 실행**: Flutter 앱을 실행하고 권한 허용
2. **모니터링 시작**: 메인 화면에서 마이크 버튼 터치
3. **음성 감지**: 5초간 주변 소리 녹음
4. **AI 분석**: 녹음된 소리를 서버로 전송하여 분석
5. **결과 표시**: 비명 감지 여부를 화면에 표시
6. **긴급 신고**: 비명 감지 시 자동으로 경찰 신고

## 향후 개선 사항

1. **실제 경찰서 API 연동**
2. **더 정확한 AI 모델 학습**
3. **배터리 최적화**
4. **다양한 언어 지원**
5. **웨어러블 기기 연동**

## 참고사항

- 현재는 데모용으로 더미 데이터를 사용
- 실제 서비스 시에는 경찰청 신고 시스템과 연동 필요
- GPS 위치 정보는 사용자 동의 하에 수집

## 라이선스

이 프로젝트는 해커톤 목적으로 제작되었습니다.