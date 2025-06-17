@echo off
setlocal
yarn install --dev
if errorlevel 1 exit /b 1

if "%FIREBASE_URL%"=="" (
  echo Error FIREBASE_URL must be set in order to build the app!
  exit /b 1
)
yarn build
if errorlevel 1 exit /b 1

docker compose up
endlocal
