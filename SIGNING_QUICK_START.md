# 🔐 Quick Code Signing Instructions

## 🎯 **Ready-to-Use Scripts**

I've created automated signing tools for your FlappyBird executables:

### 🍎 **For macOS (.app signing)**

```bash
# Run the automated script
./sign_macos_app.sh
```

**What it does:**
1. Guides you through creating a self-signed certificate
2. Signs your `dist/FlappyBird.app`  
3. Creates `FlappyBird-macOS-Signed.zip`
4. Generates user instructions

### 🪟 **For Windows (.exe signing)**

```cmd
# Run on Windows machine
sign_windows_exe.bat
```

**What it does:**
1. Creates self-signed certificate automatically
2. Signs your `dist/FlappyBird.exe`
3. Creates `FlappyBird-Windows-Signed.zip`
4. Generates user instructions

---

## ⚡ **Quick macOS Signing (Manual)**

If you prefer manual steps:

### 1. Create Certificate
- Open **Keychain Access**
- **Keychain Access** → **Certificate Assistant** → **Create a Certificate...**
- Name: `FlappyBird Developer`
- Type: `Code Signing` 
- Check **Let me override defaults**

### 2. Sign App
```bash
codesign -s "FlappyBird Developer" --force --deep dist/FlappyBird.app
```

### 3. Verify
```bash
codesign -v dist/FlappyBird.app
```

---

## 🎯 **Expected Results**

### Before Signing:
- **macOS**: "Cannot be opened because developer cannot be verified" (blocked)
- **Windows**: "Windows protected your PC" (red warning, hard to bypass)

### After Self-Signing:  
- **macOS**: Shows "Open" button directly (easier to run)
- **Windows**: "Unknown publisher" (yellow warning, easier to bypass)

### Professional Signing ($):
- **macOS**: Apple Developer ($99/year) → No warnings
- **Windows**: Code signing certificate ($200-400/year) → No warnings

---

## 📂 **Files Created**

After running the scripts, you'll have:

```
FlappyBird/
├── dist/
│   ├── FlappyBird.app (signed)          # macOS
│   └── FlappyBird.exe (signed)          # Windows  
├── FlappyBird-macOS-Signed.zip          # Distribution package
├── FlappyBird-Windows-Signed.zip        # Distribution package
├── SIGNED_APP_INSTRUCTIONS.txt          # For macOS users
├── SIGNED_EXE_INSTRUCTIONS.txt          # For Windows users
└── CODE_SIGNING_GUIDE.md               # Full technical guide
```

---

## 🚀 **Next Steps**

1. **Run the signing script** for your platform
2. **Test the signed executable** on your machine  
3. **Distri# Navigate to your project directory
cd /Users/aa961359/Documents/PERSONAL/FlappyBird

# Create a self-signed code signing certificate
security create-certificate \
  -c "FlappyBird Developer" \
  -k login \
  -T /usr/bin/codesign \
  -T /usr/bin/productbuild \
  -T /usr/bin/productsignbute the ZIP files** instead of raw executables
4. **Include the instruction files** so users know what to expect

Your self-signed apps will provide a **much better user experience** while maintaining security! 🎮✨