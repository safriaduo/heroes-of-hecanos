@echo off
setlocal
docker compose down
docker rm duelyst-db-1
docker rm duelyst-migrate-1
if exist .pgdata rmdir /s /q .pgdata
endlocal
