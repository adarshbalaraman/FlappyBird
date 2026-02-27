#!/usr/bin/env python3
"""
FlappyBird Distribution Packager
Creates user-friendly distribution packages for different platforms
"""

import os
import sys
import shutil
import zipfile
import platform
from datetime import datetime

def create_readme():
    """Create a user-friendly README for distribution"""
    readme_content = """🎮 FlappyBird Game

SYSTEM REQUIREMENTS:
• Windows 10+ (64-bit) OR macOS 10.14+
• 50 MB free space
• Graphics: DirectX 9.0c (Windows) or Metal (macOS)

HOW TO RUN:
• Windows: Double-click FlappyBird.exe
• macOS: Double-click FlappyBird.app

HOW TO PLAY:
• Use SPACEBAR or CLICK to make the bird fly
• Avoid obstacles and collect points!
• Close the game window or press ESC to quit

SECURITY NOTES:
🛡️ Windows: May show security warning - click "More info" then "Run anyway"
🍎 macOS: If blocked, right-click → "Open" → "Open" again

TROUBLESHOOTING:
• Game won't start: Make sure you meet system requirements
• Security warnings: See notes above
• Performance issues: Close other applications

Need help? This is an open source project built with Python and Pygame.

Version: {version}
Built: {date}
Platform: {platform}

Enjoy the game! 🚁"""
    
    return readme_content.format(
        version="1.0",
        date=datetime.now().strftime("%Y-%m-%d"),
        platform="Cross-platform"
    )

def package_windows():
    """Package Windows executable for distribution"""
    print("📦 Packaging Windows distribution...")
    
    if not os.path.exists("dist/FlappyBird.exe"):
        print("❌ Windows executable not found. Build it first with:")
        print("   python build_game.py")
        return False
    
    # Create package directory
    package_dir = "FlappyBird-Windows"
    if os.path.exists(package_dir):
        shutil.rmtree(package_dir)
    os.makedirs(package_dir)
    
    # Copy executable
    shutil.copy2("dist/FlappyBird.exe", package_dir)
    
    # Create README
    with open(f"{package_dir}/README.txt", "w") as f:
        f.write(create_readme())
    
    # Create system requirements file
    with open(f"{package_dir}/SYSTEM-REQUIREMENTS.txt", "w") as f:
        f.write("""FlappyBird - System Requirements

MINIMUM REQUIREMENTS:
• Operating System: Windows 10 (64-bit) or later
• Memory: 512 MB RAM
• Storage: 50 MB available space
• Graphics: DirectX 9.0c compatible graphics card
• Sound: DirectX compatible sound card (optional)

RECOMMENDED:
• Operating System: Windows 11
• Memory: 1 GB RAM
• Storage: 100 MB available space (for save files)
• Graphics: Dedicated graphics card
• Network: Internet connection for updates (if available)

NOTES:
• No additional software installation required
• Game is completely self-contained
• Antivirus software may show false positives - this is normal for PyInstaller executables
""")
    
    # Create ZIP
    zip_name = "FlappyBird-Windows.zip"
    with zipfile.ZipFile(zip_name, 'w', zipfile.ZIP_DEFLATED) as zf:
        for root, _, files in os.walk(package_dir):
            for file in files:
                file_path = os.path.join(root, file)
                arc_name = os.path.relpath(file_path, ".")
                zf.write(file_path, arc_name)
    
    # Get file sizes
    exe_size = os.path.getsize("dist/FlappyBird.exe") / (1024 * 1024)
    zip_size = os.path.getsize(zip_name) / (1024 * 1024)
    
    print(f"✅ Windows package created!")
    print(f"   📄 Executable: {exe_size:.1f} MB")
    print(f"   📦 Package: {zip_name} ({zip_size:.1f} MB)")
    
    return True

def package_macos():
    """Package macOS app bundle for distribution"""
    print("📦 Packaging macOS distribution...")
    
    if not os.path.exists("dist/FlappyBird.app"):
        print("❌ macOS app bundle not found. Build it first with:")
        print("   python build_game.py")
        return False
    
    # Create package directory
    package_dir = "FlappyBird-macOS"
    if os.path.exists(package_dir):
        shutil.rmtree(package_dir)
    os.makedirs(package_dir)
    
    # Copy app bundle
    shutil.copytree("dist/FlappyBird.app", f"{package_dir}/FlappyBird.app", 
                   symlinks=True, ignore_dangling_symlinks=True)
    
    # Create README
    with open(f"{package_dir}/README.txt", "w") as f:
        f.write(create_readme())
    
    # Create Installation Guide  
    with open(f"{package_dir}/INSTALLATION-GUIDE.txt", "w") as f:
        f.write("""FlappyBird - macOS Installation Guide

QUICK START:
1. Extract this folder anywhere on your Mac
2. Double-click FlappyBird.app to play!

INSTALLATION OPTIONS:

Option 1: Play from anywhere
• Just double-click FlappyBird.app from this folder
• Game will run directly

Option 2: Install to Applications (recommended)
1. Drag FlappyBird.app to your Applications folder
2. Find it in Launchpad or Applications folder
3. Double-click to launch

SECURITY NOTES:

If macOS shows "App cannot be opened":
1. Right-click on FlappyBird.app
2. Select "Open" from the context menu  
3. Click "Open" in the dialog that appears

Alternative method:
1. Open Terminal
2. Type: xattr -cr 
3. Drag FlappyBird.app into Terminal (this adds the path)
4. Press Enter
5. Now the app should open normally

UNINSTALLING:
• Simply drag FlappyBird.app to Trash
• No other files are created on your system

COMPATIBILITY:
• macOS 10.14 (Mojave) or later
• Works on Intel Macs and Apple Silicon (M1/M2/M3)
""")
    
    # Create ZIP (for easy distribution)
    zip_name = "FlappyBird-macOS.zip"
    with zipfile.ZipFile(zip_name, 'w', zipfile.ZIP_DEFLATED) as zf:
        for root, _, files in os.walk(package_dir):
            for file in files:
                file_path = os.path.join(root, file)
                arc_name = os.path.relpath(file_path, ".")
                zf.write(file_path, arc_name)
    
    # Get file sizes
    def get_dir_size(path):
        total = 0
        for dirpath, _, filenames in os.walk(path):
            for filename in filenames:
                filepath = os.path.join(dirpath, filename)
                total += os.path.getsize(filepath)
        return total
    
    app_size = get_dir_size("dist/FlappyBird.app") / (1024 * 1024)
    zip_size = os.path.getsize(zip_name) / (1024 * 1024)
    
    print(f"✅ macOS package created!")
    print(f"   📱 App bundle: {app_size:.1f} MB")
    print(f"   📦 Package: {zip_name} ({zip_size:.1f} MB)")
    
    return True

def main():
    """Main packaging function"""
    print("🎮 FlappyBird Distribution Packager")
    print("=" * 40)
    
    # Change to script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    
    current_platform = platform.system()
    print(f"🖥️  Current platform: {current_platform}")
    
    success = False
    
    if len(sys.argv) > 1:
        target = sys.argv[1].lower()
        if target == "windows":
            success = package_windows()
        elif target == "macos":
            success = package_macos()
        elif target == "all":
            success_win = package_windows()
            success_mac = package_macos()
            success = success_win and success_mac
        else:
            print("❌ Invalid target. Use: windows, macos, or all")
    else:
        # Auto-detect current platform
        if current_platform == "Windows":
            success = package_windows()
        elif current_platform == "Darwin":
            success = package_macos()
        else:
            print("❌ Unsupported platform. Use: python package_distribution.py [windows|macos|all]")
    
    if success:
        print("\n🎉 Distribution packages created successfully!")
        print("\n📋 Next steps:")
        print("   • Test packages on clean machines")
        print("   • Upload to GitHub releases")
        print("   • Consider code signing for security")
        print("   • Share download links!")
    else:
        print("\n❌ Packaging failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()