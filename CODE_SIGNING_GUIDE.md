# Code Signing Guide for FlappyBird

## 🍎 macOS App Signing (.app files)

### Step 1: Create Self-Signed Certificate

1. **Open Keychain Access** (Applications → Utilities → Keychain Access)

2. **Create Certificate**:
   - Menu: Keychain Access → Certificate Assistant → Create a Certificate...
   - Name: `FlappyBird Developer` (or your choice)
   - Identity Type: `Self Signed Root`
   - Certificate Type: `Code Signing`
   - Check: ✅ `Let me override defaults`
   - Click `Continue`

3. **Configure Certificate**:
   - Serial Number: `1` (default)
   - Validity Period: `365` days (or longer)
   - Email: Your email
   - Name: Your name/company
   - Click `Continue` through all steps

4. **Keychain Location**:
   - Choose: `login` (default)
   - Click `Create`

### Step 2: Sign Your .app File

```bash
# Navigate to your FlappyBird directory
cd /Users/aa961359/Documents/PERSONAL/FlappyBird

# Sign the app bundle
codesign -s "FlappyBird Developer" --force --deep --timestamp dist/FlappyBird.app

# Verify the signature
codesign -v dist/FlappyBird.app
spctl -a -t exec -v dist/FlappyBird.app
```

### Step 3: Distribute Signed App

```bash
# Create distribution ZIP
cd dist
zip -r FlappyBird-macOS-Signed.zip FlappyBird.app/

# Users can now run without right-click workaround
# (Still shows warning but allows "Open" directly)
```

---

## 🪟 Windows Exe Signing (.exe files)

### Prerequisites
- Windows machine with Windows SDK installed
- Or use OpenSSL + signtool alternative

### Method 1: Using Windows SDK (Recommended)

#### Step 1: Install Windows SDK
```cmd
# Download from: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/
# Or install via Visual Studio Installer
```

#### Step 2: Create Self-Signed Certificate
```cmd
# Open PowerShell as Administrator
# Create certificate
$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Subject "CN=FlappyBird Developer" -KeyUsage DigitalSignature -FriendlyName "FlappyBird Code Signing" -NotAfter (Get-Date).AddYears(2) -Type CodeSigningCert

# Export certificate to use with signtool
$pwd = ConvertTo-SecureString -String "your_password_here" -Force -AsPlainText
$cert | Export-PfxCertificate -FilePath "C:\temp\FlappyBird.pfx" -Password $pwd
```

#### Step 3: Sign the EXE
```cmd
# Find signtool.exe (usually in Windows SDK)
# Example path: "C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe"

# Sign the executable
signtool sign /f "C:\temp\FlappyBird.pfx" /p "your_password_here" /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 "dist\FlappyBird.exe"

# Verify signature
signtool verify /pa "dist\FlappyBird.exe"
```

### Method 2: Using OpenSSL (Cross-Platform)

#### Step 1: Install OpenSSL
```bash
# macOS (using Homebrew)
brew install openssl

# Windows (download from https://slproweb.com/products/Win32OpenSSL.html)
# Ubuntu/Linux
sudo apt-get install openssl
```

#### Step 2: Create Certificate
```bash
# Generate private key
openssl genrsa -out flappybird_private.key 2048

# Create certificate signing request
openssl req -new -key flappybird_private.key -out flappybird.csr
# When prompted, fill in:
# Country: US
# State: Your State
# City: Your City
# Organization: Your Name/Company
# Organizational Unit: Software Development
# Common Name: FlappyBird Developer
# Email: your@email.com

# Create self-signed certificate
openssl x509 -req -days 365 -in flappybird.csr -signkey flappybird_private.key -out flappybird.crt

# Convert to PKCS#12 format (for Windows)
openssl pkcs12 -export -out flappybird.pfx -inkey flappybird_private.key -in flappybird.crt
```

#### Step 3: Sign with osslsigncode (Windows EXE on any platform)
```bash
# Install osslsigncode
# macOS: brew install osslsigncode
# Ubuntu: sudo apt-get install osslsigncode

# Sign the Windows EXE
osslsigncode sign -pkcs12 flappybird.pfx -pass "your_password" -n "FlappyBird Game" -i "https://github.com/adarshbalaraman/FlappyBird" -t http://timestamp.digicert.com -in dist/FlappyBird.exe -out dist/FlappyBird-signed.exe

# Verify
osslsigncode verify dist/FlappyBird-signed.exe
```

---

## 🔒 Security Warning Improvements

### After Self-Signing:

**macOS (.app):**
- Before: "Cannot be opened because developer cannot be verified"
- After: "Developer cannot be verified" but shows "Open" button directly

**Windows (.exe):**
- Before: "Windows protected your PC" (red warning)
- After: "Unknown publisher" (yellow warning, easier to bypass)

### User Instructions for Self-Signed Apps:

**macOS Users:**
```
1. Double-click FlappyBird.app
2. Click "Open" in the security dialog
3. Game launches normally
```

**Windows Users:**
```
1. Double-click FlappyBird.exe
2. If warning appears, click "More info"
3. Click "Run anyway"
4. Game launches normally
```

---

## 🏆 Professional Signing (Optional Upgrade)

### For Commercial Distribution:

**macOS:**
- Apple Developer Program: $99/year
- Provides trusted certificates
- Enables App Store distribution
- Automatic user trust (no warnings)

**Windows:**
- Code signing certificate from CA: $200-400/year
- Providers: DigiCert, Sectigo, GlobalSign
- Immediate user trust (no warnings)
- Required for Windows Store

### Cost-Benefit Analysis:

| Method | Cost | User Trust | Setup Time |
|--------|------|------------|------------|
| Self-signed | Free | Low | 30 mins |
| Professional | $99-400/year | High | 1-2 days |

---

## 🚀 Quick Start Commands

### Sign macOS App:
```bash
# Create certificate in Keychain Access first
codesign -s "FlappyBird Developer" --force --deep dist/FlappyBird.app
```

### Sign Windows EXE (if you have Windows):
```cmd
# Create certificate first (PowerShell as Admin)
$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Subject "CN=FlappyBird Developer" -Type CodeSigningCert
signtool sign /sha1 $cert.Thumbprint /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 dist\FlappyBird.exe
```

### Verify Signatures:
```bash
# macOS
codesign -v dist/FlappyBird.app

# Windows
signtool verify /pa dist/FlappyBird.exe
```

## 📦 Distribution Package Structure

After signing, create final distribution packages:

```
FlappyBird-v1.0-macOS-Signed.zip
├── FlappyBird.app (signed)
├── README.txt
└── Installation-Guide.txt

FlappyBird-v1.0-Windows-Signed.zip
├── FlappyBird.exe (signed)  
├── README.txt
└── System-Requirements.txt
```

## ⚠️ Important Notes

1. **Self-signed certificates reduce but don't eliminate warnings**
2. **macOS**: Users still need to manually allow first run
3. **Windows**: SmartScreen may still show warnings initially
4. **Professional certificates**: Only way to completely eliminate warnings
5. **Time-stamping**: Ensures signatures remain valid after certificate expires

Your signed executables will provide a much better user experience while maintaining security! 🎮🔒