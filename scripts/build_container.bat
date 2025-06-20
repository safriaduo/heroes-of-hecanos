@echo off
setlocal
set SERVICE=%1
if "%SERVICE%"=="" (
  echo Usage: build_container.bat ^<service^> ^<version^> [platform]
  exit /b 1
)
set VERSION=%2
if "%VERSION%"=="" set VERSION=testing
set PLATFORM=%3
if "%PLATFORM%"=="" set PLATFORM=linux/arm64

echo Building image for duelyst-nodejs:%VERSION% for %PLATFORM%.
docker buildx build --platform %PLATFORM% -f docker\nodejs.Dockerfile -t duelyst-nodejs:%VERSION% --load .
if errorlevel 1 goto error

docker buildx build --platform %PLATFORM% -f docker\%SERVICE%.Dockerfile -t duelyst-%SERVICE%:%VERSION% --build-arg NODEJS_IMAGE_VERSION=%VERSION% --load .
if errorlevel 1 goto error

echo Successfully built image duelyst-%SERVICE%:%VERSION%
exit /b 0

:error
echo Failed to build image!
exit /b 1
