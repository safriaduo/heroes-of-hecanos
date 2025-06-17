@echo off
setlocal
set SERVICE=%1
if "%SERVICE%"=="" (
  echo Usage: build_container.bat ^<service^> ^<version^>
  exit /b 1
)
set VERSION=%2
if "%VERSION%"=="" set VERSION=testing

echo Building image for duelyst-nodejs:%VERSION%.
docker build -f docker\nodejs.Dockerfile -t duelyst-nodejs:%VERSION% .
if errorlevel 1 goto error

docker build -f docker\%SERVICE%.Dockerfile -t duelyst-%SERVICE%:%VERSION% --build-arg NODEJS_IMAGE_VERSION=%VERSION% .
if errorlevel 1 goto error

echo Successfully built image duelyst-%SERVICE%:%VERSION%
exit /b 0

:error
echo Failed to build image!
exit /b 1
