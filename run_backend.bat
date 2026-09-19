@echo off
setlocal
chcp 65001 >nul
set "JAVA_HOME=C:\Program Files\Java\jdk-21.0.10"
set "PATH=%JAVA_HOME%\bin;%PATH%"

for %%I in ("%~dp0.") do set "PROJECT_DIR=%%~sI"

cd /d "%PROJECT_DIR%\backend"
if exist "C:\Users\Admin\Documents\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin\mvn.cmd" (
    call "C:\Users\Admin\Documents\apache-maven-3.9.11-bin\apache-maven-3.9.11\bin\mvn.cmd" spring-boot:run
) else (
    call "%PROJECT_DIR%\.tools\apache-maven-3.9.9\bin\mvn.cmd" spring-boot:run
)
pause
