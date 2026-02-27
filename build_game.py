#!/usr/bin/env python3
"""
Cross-platform build script for FlappyBird
This script will build executables for the current platform
"""

import os
import sys
import subprocess
import shutil
import platform

def clean_build_dirs():
    """Clean build and dist directories"""
    print("🧹 Cleaning build directories...")
    for dir_name in ['build', 'dist']:
        if os.path.exists(dir_name):
            try:
                shutil.rmtree(dir_name)
                print(f"   ✅ Removed {dir_name}/")
            except OSError as e:
                print(f"   ⚠️  Warning: Could not remove {dir_name}/ ({e})")
                print(f"       Trying to clean contents...")
                try:
                    for item in os.listdir(dir_name):
                        item_path = os.path.join(dir_name, item)
                        if os.path.isdir(item_path):
                            shutil.rmtree(item_path)
                        else:
                            os.remove(item_path)
                    print(f"   ✅ Cleaned {dir_name}/ contents")
                except OSError as e2:
                    print(f"   ❌ Could not clean {dir_name}/: {e2}")
        else:
            print(f"   ℹ️  {dir_name}/ doesn't exist")

def check_pyinstaller():
    """Check if PyInstaller is installed"""
    try:
        subprocess.run([sys.executable, '-m', 'PyInstaller', '--version'], 
                      capture_output=True, check=True)
        print("✅ PyInstaller is available")
    except subprocess.CalledProcessError:
        print("❌ PyInstaller not found. Installing...")
        subprocess.run([sys.executable, '-m', 'pip', 'install', 'pyinstaller'], check=True)
        print("✅ PyInstaller installed")

def build_executable():
    """Build executable for current platform"""
    current_platform = platform.system()
    print(f"🔨 Building for {current_platform}...")
    
    if current_platform == "Windows":
        spec_file = "FlappyBird-windows.spec"
        print("   Using Windows configuration...")
    else:
        spec_file = "FlappyBird.spec"  # Default spec works for macOS/Linux
        print("   Using macOS/Linux configuration...")
    
    if not os.path.exists(spec_file):
        print(f"❌ Spec file {spec_file} not found!")
        return False
    
    try:
        subprocess.run([sys.executable, '-m', 'PyInstaller', spec_file], check=True)
        print(f"✅ Build completed successfully for {current_platform}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Build failed: {e}")
        return False

def list_outputs():
    """List the created executable files"""
    print("\n📦 Build outputs:")
    dist_path = "dist"
    if os.path.exists(dist_path):
        for item in os.listdir(dist_path):
            item_path = os.path.join(dist_path, item)
            if os.path.isdir(item_path):
                print(f"   📁 {item}/")
                # List contents of directories
                for subitem in os.listdir(item_path)[:5]:  # Limit to first 5 items
                    print(f"      📄 {subitem}")
                if len(os.listdir(item_path)) > 5:
                    print(f"      ... and {len(os.listdir(item_path)) - 5} more files")
            else:
                size = os.path.getsize(item_path) / (1024 * 1024)  # Size in MB
                print(f"   📄 {item} ({size:.1f} MB)")
    else:
        print("   ❌ No dist directory found")

def main():
    """Main build function"""
    print("🎮 FlappyBird Cross-Platform Builder")
    print("=" * 40)
    
    # Change to script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)
    print(f"📂 Working directory: {script_dir}")
    
    # Clean previous builds
    clean_build_dirs()
    
    # Check PyInstaller
    check_pyinstaller()
    
    # Build
    success = build_executable()
    
    if success:
        list_outputs()
        print("\n🎉 Build completed successfully!")
        print("\n📖 To run your game:")
        
        current_platform = platform.system()
        if current_platform == "Windows":
            print("   Windows: Run dist/FlappyBird.exe")
        elif current_platform == "Darwin":
            print("   macOS: Open dist/FlappyBird.app or run dist/FlappyBird/FlappyBird")
        else:
            print("   Linux: Run dist/FlappyBird/FlappyBird")
    else:
        print("❌ Build failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()