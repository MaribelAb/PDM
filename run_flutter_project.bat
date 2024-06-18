@echo off

cd Centaur\flutter_frontend\centaur_flutter
REM Check for connected devices
set "flutter_command=flutter run"
for /f "tokens=*" %%i in ('flutter devices') do (
    echo %%i | findstr /r /c:"•.*\(mobile\)" >nul && (
        set "flutter_command=flutter run"
        goto :found_device
    )
)

REM If no mobile device found, check for browsers
:found_device
if "%flutter_command%"=="flutter run" (
    goto :run_flutter
)

if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    set "flutter_command=flutter run -d edge"
) else if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    set "flutter_command=flutter run -d chrome"
) else if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" (
    set "flutter_command=flutter run -d chrome"
) else (
    echo No supported browser found for flutter run. Please install Edge or Chrome.
    pause
    exit /b 1
)

:run_flutter

REM Run the Flutter command
%flutter_command%

REM Keep the current command prompt open after executing the commands
pause
