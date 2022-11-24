@echo off

cd /d %~dp0

echo ****************************
echo.
echo       アプリインストール         
echo.
echo ****************************
echo.
echo.
echo 管理者権限で実行してください
pause

powershell -NoProfile -ExecutionPolicy Unrestricted .\04_アプリインストール.ps1

pause

exit /b
