@echo off
setlocal
set VERSION=%1
set REGISTRY=%2
if "%VERSION%"=="" goto usage
if "%REGISTRY%"=="" goto usage

for %%i in ("%cd%") do set CURDIR=%%~nxi
if /I NOT "%CURDIR%"=="heroes-of-hecanos" (
  echo Run this from the repo root.
  exit /b 1
)

for %%s in (api game migrate sp worker) do (
  call "%~dp0build_container.bat" %%s %VERSION%
  if errorlevel 1 exit /b 1
  call "%~dp0publish_container.bat" %%s %VERSION% %REGISTRY%
  if errorlevel 1 exit /b 1
)
exit /b 0

:usage
echo Usage: release_containers.bat ^<version^> ^<ecr-registry-id^>
endlocal
exit /b 1
