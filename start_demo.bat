@echo off
echo ========================================
echo Safe Voice - 해커톤 데모 시작
echo ========================================
echo.

echo 1. Flutter 의존성 설치 중...
cd flutter_app
call flutter pub get
if errorlevel 1 (
    echo Flutter 설치 실패. Flutter가 설치되어 있는지 확인하세요.
    pause
    exit /b 1
)

echo.
echo 2. Flutter 웹앱 빌드 중...
call flutter build web
if errorlevel 1 (
    echo 빌드 실패.
    pause
    exit /b 1
)

echo.
echo 3. 컴퓨터 IP 주소:
ipconfig | findstr "IPv4"

echo.
echo 4. HTTP 서버 시작 중...
cd build\web
echo 서버 주소: http://[위IP]:5000
echo 모바일에서 위 주소로 접속하세요!
echo.
echo 서버를 중지하려면 Ctrl+C를 누르세요.
echo.
npx http-server -p 5000 -a 0.0.0.0 --cors -c-1