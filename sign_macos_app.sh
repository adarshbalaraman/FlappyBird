#!/bin/bash
# FlappyBird macOS Code Signing Script
# This script will sign your FlappyBird.app with a self-signed certificate

echo "🎮 FlappyBird macOS Code Signing Tool"
echo "=" * 40

# Check if .app exists
if [ ! -d "dist/FlappyBird.app" ]; then
    echo "❌ FlappyBird.app not found in dist/ folder"
    echo "   Please build the app first with: python build_game.py"
    exit 1
fi

echo "✅ Found FlappyBird.app"

# List available code signing identities
echo ""
echo "📋 Available code signing identities:"
security find-identity -v -p codesigning

echo ""
echo "🔐 Code signing options:"
echo "1. Use existing code signing identity (if you have one)"
echo "2. Create new self-signed certificate"
echo "3. Skip signing (exit)"

read -p "Choose option (1-3): " choice

case $choice in
    1)
        read -p "Enter your signing identity name (e.g., 'Developer ID Application: Your Name'): " identity
        ;;
    2)
        echo ""
        echo "🛠️  Creating self-signed certificate..."
        echo ""
        echo "⚠️  MANUAL STEP REQUIRED:"
        echo "1. Open Keychain Access (Cmd+Space, type 'Keychain Access')"
        echo "2. Go to: Keychain Access → Certificate Assistant → Create a Certificate..."
        echo "3. Enter these settings:"
        echo "   - Name: FlappyBird Developer"
        echo "   - Identity Type: Self Signed Root"
        echo "   - Certificate Type: Code Signing"
        echo "   - Check: 'Let me override defaults'"
        echo "4. Click Continue through all steps"
        echo "5. Choose 'login' keychain"
        echo "6. Click Create"
        echo ""
        read -p "Press ENTER when you've completed the certificate creation..."
        
        identity="FlappyBird Developer"
        ;;
    3)
        echo "👋 Exiting without signing"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "🔏 Signing FlappyBird.app with identity: $identity"

# Remove existing signatures (if any)
echo "   Removing existing signatures..."
codesign --remove-signature dist/FlappyBird.app 2>/dev/null || true

# Sign the app
echo "   Signing application..."
if codesign -s "$identity" --force --deep --timestamp --options runtime dist/FlappyBird.app; then
    echo "✅ Signing successful!"
else
    echo "❌ Signing failed!"
    echo ""
    echo "💡 Common solutions:"
    echo "1. Make sure the certificate exists in Keychain Access"
    echo "2. Check the identity name matches exactly"
    echo "3. Try without --timestamp option if offline"
    exit 1
fi

# Verify the signature
echo ""
echo "🔍 Verifying signature..."
if codesign -v dist/FlappyBird.app; then
    echo "✅ Signature verification passed!"
else
    echo "❌ Signature verification failed!"
    exit 1
fi

# Test macOS Gatekeeper assessment
echo ""
echo "🛡️  Testing Gatekeeper assessment..."
if spctl -a -t exec -v dist/FlappyBird.app 2>/dev/null; then
    echo "✅ Gatekeeper assessment passed!"
else
    echo "⚠️  Gatekeeper assessment failed (expected for self-signed)"
    echo "   This is normal for self-signed certificates"
fi

# Show detailed signature info
echo ""
echo "📋 Signature details:"
codesign -dv dist/FlappyBird.app

# Create signed distribution package
echo ""
echo "📦 Creating signed distribution package..."
cd dist
if [ -f FlappyBird-macOS-Signed.zip ]; then
    rm FlappyBird-macOS-Signed.zip
fi

zip -r FlappyBird-macOS-Signed.zip FlappyBird.app/
file_size=$(du -sh FlappyBird-macOS-Signed.zip | cut -f1)

echo "✅ Created: FlappyBird-macOS-Signed.zip ($file_size)"

# Create user instructions
cat > ../SIGNED_APP_INSTRUCTIONS.txt << 'EOF'
🎮 FlappyBird - Signed macOS App Instructions

Your FlappyBird.app has been code signed to reduce security warnings!

INSTALLATION:
1. Extract FlappyBird-macOS-Signed.zip
2. Drag FlappyBird.app to your Applications folder (optional)
3. Double-click FlappyBird.app to run

FIRST RUN:
• macOS may still show a security dialog (this is normal for self-signed apps)
• Click "Open" in the dialog to run the game
• Subsequent runs will launch without warnings

WHAT CHANGED:
• Before signing: "Cannot be opened because developer cannot be verified"
• After signing: Shows "Open" button directly in the security dialog

TECHNICAL INFO:
• App is signed with a self-signed certificate
• This reduces but doesn't eliminate security warnings
• Professional apps use certificates from Apple ($99/year)

TROUBLESHOOTING:
• If app won't open: Right-click → Open → Open
• If still blocked: Go to System Preferences → Security & Privacy → General
• Look for "FlappyBird.app was blocked" and click "Open Anyway"

ENJOY THE GAME! 🚁
EOF

cd ..
echo "📋 Created: SIGNED_APP_INSTRUCTIONS.txt"

echo ""
echo "🎉 Code signing complete!"
echo ""
echo "📁 Files created:"
echo "   • dist/FlappyBird-macOS-Signed.zip"
echo "   • SIGNED_APP_INSTRUCTIONS.txt"
echo ""
echo "📤 Ready for distribution!"
echo "   Your app now provides a better user experience with reduced security warnings."