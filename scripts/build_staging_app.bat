@echo off
setlocal
if "%FIREBASE_URL%"=="" (
  echo Error: FIREBASE_URL must be set in order to build the app!
  exit /b 1
)
if "%API_URL%"=="" (
  echo Error: API_URL must be set in order to build the app!
)

if exist node_modules rmdir /s /q node_modules

yarn install --dev
if errorlevel 1 exit /b 1

set NODE_ENV=staging
yarn build:withallrsx
if errorlevel 1 exit /b 1

endlocal
