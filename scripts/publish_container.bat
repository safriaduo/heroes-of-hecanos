@echo off
setlocal
set SERVICE=%1
if "%SERVICE%"=="" (
  echo Usage: publish_container.bat ^<service^> ^<version^> ^<ecr-registry-id^>
  exit /b 1
)
set VERSION=%2
if "%VERSION%"=="" (
  echo Usage: publish_container.bat ^<service^> ^<version^> ^<ecr-registry-id^>
  exit /b 1
)
set REGISTRY=%3
if "%REGISTRY%"=="" (
  echo Usage: publish_container.bat ^<service^> ^<version^> ^<ecr-registry-id^>
  exit /b 1
)

where aws >nul 2>&1
if errorlevel 1 (
  echo AWS CLI is not installed. Exiting.
  exit /b 1
)
aws sts get-caller-identity >nul 2>&1
if errorlevel 1 (
  echo Not authenticated on the AWS CLI. Exiting.
  exit /b 1
)

echo Authenticating with ECR.
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
if errorlevel 1 (
  echo Failed to authenticate.
  exit /b 1
)
set LOCAL_IMAGE=duelyst-%SERVICE%:%VERSION%
set REMOTE_IMAGE=public.ecr.aws/%REGISTRY%/duelyst-%SERVICE%:%VERSION%
echo Tagging %LOCAL_IMAGE% as %REMOTE_IMAGE%
docker tag %LOCAL_IMAGE% %REMOTE_IMAGE%
echo Pushing %REMOTE_IMAGE%
docker push %REMOTE_IMAGE%

set REMOTE_IMAGE=public.ecr.aws/%REGISTRY%/duelyst-%SERVICE%:latest
echo Tagging %LOCAL_IMAGE% as %REMOTE_IMAGE%
docker tag %LOCAL_IMAGE% %REMOTE_IMAGE%
echo Pushing %REMOTE_IMAGE%
docker push %REMOTE_IMAGE%

endlocal
