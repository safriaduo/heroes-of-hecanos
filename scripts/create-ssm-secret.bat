@echo off
setlocal
set KMS_KEY_ID=%1
if "%KMS_KEY_ID%"=="" (
  echo First argument must be KMS_KEY_ID (UUID)!
  exit /b 1
)
set NAME=%2
if "%NAME%"=="" (
  echo Second argument must be NAME e.g. /path/to/my/secret!
  exit /b 1
)
set VALUE=%3
if "%VALUE%"=="" (
  echo Third argument must be VALUE e.g. my-secret!
  exit /b 1
)
aws ssm put-parameter --type SecureString --key-id %KMS_KEY_ID% --name %NAME% --value %VALUE%
endlocal
