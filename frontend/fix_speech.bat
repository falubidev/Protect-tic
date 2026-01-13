@echo off
cd /d "%~dp0"
echo Limpiando caché...
flutter clean
echo Forzando instalación de speech_to_text...
del pubspec.lock
rmdir /s /q .dart_tool
flutter pub get
pause
