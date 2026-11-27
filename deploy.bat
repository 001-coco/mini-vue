@echo off
chcp 65001 >nul
title mini-vue · 部署到 Netlify
cd /d "%~dp0"

echo ========================================
echo   mini-vue 演示页 · 构建并部署
echo ========================================
echo.

call npm run build
if errorlevel 1 (
  echo [错误] 构建失败
  pause
  exit /b 1
)

call netlify deploy --prod --dir=dist --site 5da1acc8-ceda-4f75-ab99-bc0474a51200

echo.
echo 部署完成：https://mini-vue-coco.netlify.app
echo.
pause
