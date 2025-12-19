@echo off
set JAVA_HOME=C:\Program Files\jdk-17.0.12
set GRADLE_HOME=
cd /d "d:\Android IOs\LabFinal\twitter"
call flutter build apk --release
pause
