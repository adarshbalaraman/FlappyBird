# FlappyBird - Cross-Platform Build Instructions

This guide explains how to build FlappyBird executables for Windows and macOS.

## 🚀 Quick Build (Current Platform)

For a quick build on your current platform:

```bash
python build_game.py
```

This will automatically:
- Clean previous builds
- Install PyInstaller if needed  
- Build for your current platform
- Show you where the executable is located

## 🖥️ Platform-Specific Instructions

### macOS Build

**Prerequisites:**
- Python 3.7+ installed
- pygame installed (`pip install pygame`)

**Building:**
```bash
# Using the cross-platform script (recommended)
python build_game.py

# OR manually using PyInstaller
pip install pyinstaller
pyinstaller FlappyBird.spec
```

**Output:**
- **App Bundle**: `dist/FlappyBird.app` (double-click to run)
- **Executable**: `dist/FlappyBird/FlappyBird` (run from terminal)

### Windows Build

**Prerequisites:**
- Python 3.7+ installed
- pygame installed (`pip install pygame`)

**Building:**
```cmd
# Using the cross-platform script (recommended)
python build_game.py

# OR manually using PyInstaller
pip install pyinstaller
pyinstaller FlappyBird-windows.spec
```

**Output:**
- **Single Executable**: `dist/FlappyBird.exe` (double-click to run)

## 🛠️ Manual Build Process

### Step 1: Clean Previous Builds
```bash
rm -rf build/ dist/  # macOS/Linux
rmdir /s build dist  # Windows Command Prompt
```

### Step 2: Install Dependencies
```bash
pip install pyinstaller pygame
```

### Step 3: Build for Your Platform

**macOS/Linux:**
```bash
pyinstaller FlappyBird.spec
```

**Windows:**
```cmd
pyinstaller FlappyBird-windows.spec
```

## 📁 Build Output Structure

### macOS
```
dist/
├── FlappyBird.app/          # macOS app bundle
└── FlappyBird/              # Directory distribution
    ├── FlappyBird           # Executable
    └── _internal/           # Dependencies
```

### Windows
```
dist/
└── FlappyBird.exe          # Single executable file
```

## 🔧 Customizing the Build

### Changing the Icon
1. Add your icon file to the project root:
   - Windows: `icon.ico`
   - macOS: `icon.icns`
2. Edit the spec file and update the `icon` parameter:
   ```python
   icon='icon.ico',  # or 'icon.icns'
   ```

### Build Configuration Options

Edit the `.spec` files to customize:
- **Console window**: `console=True/False`
- **One-file vs directory**: Use different spec configurations
- **Optimization**: `optimize=1` for smaller builds
- **Excluded modules**: Add to `excludes=[]`

## 🐛 Troubleshooting

### Common Issues

**"Module not found" errors:**
- Add missing modules to `hiddenimports=[]` in the spec file
- Install all dependencies: `pip install pygame`

**Large executable size:**
- Use `optimize=1` in the spec file
- Add unnecessary modules to `excludes=[]`

**Windows Defender warnings:**
- This is normal for PyInstaller executables
- The `upx=False` setting helps reduce false positives

**macOS security warnings:**
- Run: `xattr -cr dist/FlappyBird.app` to remove quarantine attributes
- Or right-click → Open to bypass Gatekeeper

### Platform-Specific Issues

**macOS:**
- If you get permission errors, run: `chmod +x dist/FlappyBird/FlappyBird`

**Windows:**
- Use Command Prompt or PowerShell, not Git Bash
- Ensure Python is in your PATH

## 📦 Distribution

### For Other Computers

**Quick packaging:**
```bash
python package_distribution.py          # Auto-detect platform
python package_distribution.py windows  # Package for Windows
python package_distribution.py macos    # Package for macOS  
python package_distribution.py all      # Package for both
```

This creates user-friendly packages with README files and installation guides.

### macOS
- Distribute the entire `FlappyBird.app` bundle
- Or zip the `FlappyBird/` directory
- **For best results**: Use the packager script above

### Windows  
- Distribute the single `FlappyBird.exe` file
- No additional files needed
- **For best results**: Use the packager script above

### Security Notes
- **Windows**: Antivirus may show warnings (normal for PyInstaller)
- **macOS**: Users may need to right-click → "Open" for unsigned apps
- **Solution**: Consider code signing for professional distribution

See [DISTRIBUTION_GUIDE.md](DISTRIBUTION_GUIDE.md) for detailed instructions.

## 🔄 Automated Cross-Platform Building

For building on both platforms automatically, consider using GitHub Actions:

1. The project includes platform-specific spec files
2. Use the `build_game.py` script in your CI/CD pipeline
3. Artifacts will be generated for each platform

## 🎮 Running the Game

After building:
- **macOS**: Double-click `FlappyBird.app` or run `./dist/FlappyBird/FlappyBird`
- **Windows**: Double-click `FlappyBird.exe`

The game will automatically detect the correct resource paths whether running from source or as a packaged executable.