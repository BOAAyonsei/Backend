# Safe Voice - 빠른 시작 가이드

## 🚀 다른 컴퓨터에서 실행하기

### 1. 저장소 클론
```bash
git clone [YOUR_REPO_URL]
cd Safe_Voice
```

### 2. Flutter 웹앱 빌드 및 실행
```bash
# Flutter 의존성 설치
cd flutter_app
flutter pub get

# 웹앱 빌드
flutter build web

# HTTP 서버로 실행 (Node.js 필요)
cd build/web
npx http-server -p 5000 -a 0.0.0.0 --cors -c-1
```

### 3. 모바일에서 접속
- 같은 WiFi에 연결
- `http://[컴퓨터IP]:5000` 접속
- 컴퓨터 IP 확인: `ipconfig` (Windows) 또는 `ifconfig` (Mac/Linux)

### 4. 백엔드 서버 (선택사항)
```bash
# Python Flask 서버
cd backend
pip install -r requirements.txt
python app.py

# Spring Boot 서버
cd spring_backend
mvn spring-boot:run
```

## 📱 사용법
1. 모바일 웹앱에서 분홍색 마이크 버튼 클릭
2. 5초간 "음성 모니터링 중..." 대기
3. 30% 확률로 "위험 상황 감지!" 알림 표시

## 🛠️ 필요한 도구
- Flutter SDK
- Node.js (http-server용)
- Python 3.x (백엔드용, 선택사항)
- Java 17+ (Spring Boot용, 선택사항)

## 🎯 해커톤 데모
웹앱만으로도 완전한 데모 가능! 백엔드 없이도 작동합니다.