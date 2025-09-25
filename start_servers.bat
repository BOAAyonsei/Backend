@echo off
echo Starting Safe Voice Servers...

echo.
echo Starting Python Flask Server (Port 5000)...
cd /d "C:\Safe_Voice\backend"
start "Python Flask Server" cmd /k "python app.py"

echo.
echo Waiting 5 seconds for Python server to start...
timeout /t 5 /nobreak >nul

echo Starting Spring Boot Server (Port 8080)...
cd /d "C:\Safe_Voice\spring_backend"
start "Spring Boot Server" cmd /k "mvn spring-boot:run"

echo.
echo Both servers are starting...
echo Python Flask API: http://localhost:5000
echo Spring Boot API: http://localhost:8080
echo.
echo You can now run the Flutter app with: flutter run
pause