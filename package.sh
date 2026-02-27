#!/bin/bash
# Cross-platform packaging script for Flappy Bird Game

echo "=== Flappy Bird Cross-Platform Packaging ==="
echo ""

# Activate virtual environment
source .venv/bin/activate

# Package for current platform (macOS)
echo "📦 Creating macOS distribution..."
pyinstaller --clean FlappyBird.spec --noconfirm

# Check if build was successful
if [ -d "dist/FlappyBird" ] && [ -d "dist/FlappyBird.app" ]; then
    echo "✅ macOS build successful!"
    
    # Get file sizes
    exe_size=$(du -sh dist/FlappyBird | cut -f1)
    app_size=$(du -sh dist/FlappyBird.app | cut -f1)
    
    echo ""
    echo "📊 Distribution sizes:"
    echo "   • Standalone executable: $exe_size"
    echo "   • macOS App bundle: $app_size"
    echo ""
    
    # Create distribution readme
    echo "🗂️  Creating distribution information..."
    
    cat > dist/README.md << 'EOF'
# Flappy Bird Drone - Archaeology Quiz Edition

## Distribution Package

This package contains the complete Flappy Bird Drone game with educational archaeology quiz questions.

### Contents

#### For macOS:
- **FlappyBird.app** - Double-click to install and run (drag to Applications folder)
- **FlappyBird/** - Standalone executable version

#### For Windows:
- Use the Windows distribution package created separately

### System Requirements

#### macOS:
- macOS 10.14 or later
- 64-bit Intel or Apple Silicon processor

#### Windows:
- Windows 10 or later
- 64-bit processor

### How to Play

1. **Start the Game**: Click "START GAME" on the dark green start screen
2. **Control the Drone**: Click or tap to make the drone fly up
3. **Avoid Obstacles**: Navigate through gaps between pipes
4. **Answer Quiz Questions**: When you crash, answer archaeology questions to continue
5. **Score Points**: Each second you survive adds to your score
6. **Restart**: Use the "RESTART GAME" button when game ends

### Game Features

- **Educational Content**: 50+ archaeology quiz questions
- **Progressive Difficulty**: Quiz questions help you continue the game
- **Score Tracking**: Accumulated score across multiple quiz rounds
- **Professional Graphics**: Custom drone and environment artwork
- **Sound Effects**: Background music and game sounds

### Company

Developed by **TechtonicBotz**

### Version Information

- Version: 1.0.0
- Build Date: $(date)
- Platform: Cross-platform (macOS/Windows)

---
Enjoy learning about archaeology while flying your drone! 🎮🏛️
EOF
    
    echo "✅ Distribution complete!"
    echo ""
    echo "📁 Find your packaged game in the 'dist/' directory:"
    echo "   • dist/FlappyBird.app (macOS application)"
    echo "   • dist/FlappyBird/ (standalone executable)"
    echo "   • dist/README.md (distribution information)"
    echo ""
    echo "🚀 Ready for distribution!"
    
else
    echo "❌ Build failed! Check the output above for errors."
    exit 1
fi