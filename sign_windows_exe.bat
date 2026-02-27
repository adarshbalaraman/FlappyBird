@echo off
REM FlappyBird Windows Code Signing Script
REM This script will sign your FlappyBird.exe with a self-signed certificate

echo 🎮 FlappyBird Windows Code Signing Tool
echo ========================================

REM Check if .exe exists
if not exist "dist\FlappyBird.exe" (
    echo ❌ FlappyBird.exe not found in dist\ folder
    echo    Please build the Windows executable first
    exit /b 1
)

echo ✅ Found FlappyBird.exe

echo.
echo 🔐 Code signing options:
echo 1. Create new self-signed certificate and sign
echo 2. Use existing certificate file (.pfx)
echo 3. Skip signing (exit)
echo.

set /p choice="Choose option (1-3): "

if "%choice%"=="1" goto create_cert
if "%choice%"=="2" goto use_existing
if "%choice%"=="3" goto exit_script

echo ❌ Invalid choice
exit /b 1

:create_cert
echo.
echo 🛠️  Creating self-signed certificate...

REM Check if PowerShell is available
powershell -Command "Write-Host 'PowerShell available'" >nul 2>&1
if errorlevel 1 (
    echo ❌ PowerShell not found. Please install PowerShell or use option 2.
    exit /b 1
)

REM Create certificate using PowerShell
set cert_name=FlappyBird Developer
set cert_password=FlappyBird123!

echo    Creating certificate...
powershell -Command "$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Subject 'CN=%cert_name%' -KeyUsage DigitalSignature -FriendlyName '%cert_name%' -NotAfter (Get-Date).AddYears(2) -Type CodeSigningCert; Write-Host 'Certificate created with thumbprint:' $cert.Thumbprint; $pwd = ConvertTo-SecureString -String '%cert_password%' -Force -AsPlainText; $cert | Export-PfxCertificate -FilePath 'FlappyBird.pfx' -Password $pwd; Write-Host 'Certificate exported to FlappyBird.pfx'"

if errorlevel 1 (
    echo ❌ Certificate creation failed
    exit /b 1
)

set cert_file=FlappyBird.pfx
set cert_pass=%cert_password%
goto sign_exe

:use_existing
echo.
set /p cert_file="Enter path to certificate file (.pfx): "
set /p cert_pass="Enter certificate password: "

if not exist "%cert_file%" (
    echo ❌ Certificate file not found: %cert_file%
    exit /b 1
)

:sign_exe
echo.
echo 🔍 Looking for signtool.exe...

REM Common locations for signtool.exe
set "signtool_paths="C:\Program Files (x86)\Windows Kits\10\bin\x64\signtool.exe" "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe" "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\signtool.exe" "C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\x64\signtool.exe""

set signtool_found=0
for %%i in (%signtool_paths%) do (
    if exist %%i (
        set "signtool=%%i"
        set signtool_found=1
        echo ✅ Found signtool: %%i
        goto sign_now
    )
)

if %signtool_found%==0 (
    echo ❌ signtool.exe not found!
    echo.
    echo 💡 To install signtool:
    echo 1. Download Windows SDK from:
    echo    https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/
    echo 2. Or install Visual Studio with Windows SDK components
    echo.
    echo 📝 Manual signing command:
    echo signtool sign /f "%cert_file%" /p "%cert_pass%" /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 "dist\FlappyBird.exe"
    exit /b 1
)

:sign_now
echo.
echo 🔏 Signing FlappyBird.exe...

"%signtool%" sign /f "%cert_file%" /p "%cert_pass%" /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 "dist\FlappyBird.exe"

if errorlevel 1 (
    echo ❌ Signing failed!
    echo.
    echo 💡 Try signing without timestamp if offline:
    echo "%signtool%" sign /f "%cert_file%" /p "%cert_pass%" /fd SHA256 "dist\FlappyBird.exe"
    exit /b 1
)

echo ✅ Signing successful!

echo.
echo 🔍 Verifying signature...
"%signtool%" verify /pa "dist\FlappyBird.exe"

if errorlevel 1 (
    echo ⚠️  Signature verification had warnings (this is normal for self-signed)
) else (
    echo ✅ Signature verification passed!
)

echo.
echo 📦 Creating signed distribution package...

if exist "FlappyBird-Windows-Signed.zip" del "FlappyBird-Windows-Signed.zip"

REM Create ZIP using PowerShell (built into Windows 10+)
powershell -Command "Compress-Archive -Path 'dist\FlappyBird.exe', 'USER_INSTRUCTIONS.txt' -DestinationPath 'FlappyBird-Windows-Signed.zip'"

if errorlevel 1 (
    echo ⚠️  Could not create ZIP automatically
    echo 📂 Manually create ZIP with:
    echo    - dist\FlappyBird.exe
    echo    - USER_INSTRUCTIONS.txt
) else (
    echo ✅ Created: FlappyBird-Windows-Signed.zip
)

REM Create user instructions
echo Creating user instructions...
(
echo 🎮 FlappyBird - Signed Windows Executable Instructions
echo.
echo Your FlappyBird.exe has been code signed to reduce security warnings!
echo.
echo INSTALLATION:
echo 1. Extract FlappyBird-Windows-Signed.zip
echo 2. Double-click FlappyBird.exe to run
echo.
echo FIRST RUN:
echo • Windows may show SmartScreen warning ^(this is normal for self-signed apps^)
echo • Click "More info" then "Run anyway" to start the game
echo • Subsequent runs may have fewer warnings
echo.
echo WHAT CHANGED:
echo • Before signing: Red "Windows protected your PC" warning
echo • After signing: Yellow "Unknown publisher" warning ^(easier to bypass^)
echo.
echo TECHNICAL INFO:
echo • Executable is signed with a self-signed certificate
echo • This reduces but doesn't eliminate security warnings
echo • Professional apps use certificates from Trusted CAs ^($200-400/year^)
echo.
echo TROUBLESHOOTING:
echo • If exe won't run: Right-click → Properties → Unblock
echo • Add to Windows Defender exclusions if needed
echo • Run as Administrator if standard user doesn't work
echo.
echo ENJOY THE GAME! 🚁
) > SIGNED_EXE_INSTRUCTIONS.txt

echo 📋 Created: SIGNED_EXE_INSTRUCTIONS.txt

echo.
echo 🎉 Code signing complete!
echo.
echo 📁 Files created:
echo    • FlappyBird-Windows-Signed.zip
echo    • SIGNED_EXE_INSTRUCTIONS.txt
if exist "FlappyBird.pfx" echo    • FlappyBird.pfx ^(certificate file^)
echo.
echo 📤 Ready for distribution!
echo    Your executable now provides a better user experience with reduced security warnings.
goto end

:exit_script
echo 👋 Exiting without signing

:end
pause