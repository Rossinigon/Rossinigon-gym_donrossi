@echo off
set "PATH=C:\src\flutter\bin;C:\Program Files\Git\cmd;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32"
cd /d C:\Users\rossi\gym_donrossi
set "PATH=C:\src\flutter\bin;C:\Program Files\Git\cmd;C:\Windows\System32;C:\Windows"
flutter build apk --release > build_output.log 2>&1
echo Compilação terminada. Verifique o ficheiro build_output.log
pause