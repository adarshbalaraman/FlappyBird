#!/usr/bin/env python3
"""
Audio converter for FlappyBird web compatibility
Converts WAV files to OGG format for pygbag web deployment
"""

import os
from pydub import AudioSegment

def convert_wav_to_ogg(input_dir, output_dir):
    """Convert WAV files to OGG format"""
    
    # Create output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    print("🎵 Converting audio files for web compatibility...")
    
    # Get all WAV files
    wav_files = [f for f in os.listdir(input_dir) if f.endswith('.wav')]
    
    if not wav_files:
        print("❌ No WAV files found in", input_dir)
        return False
    
    converted_files = []
    
    for wav_file in wav_files:
        try:
            input_path = os.path.join(input_dir, wav_file)
            output_filename = wav_file.replace('.wav', '.ogg')
            output_path = os.path.join(output_dir, output_filename)
            
            print(f"   Converting: {wav_file} → {output_filename}")
            
            # Load and convert
            audio = AudioSegment.from_wav(input_path)
            audio.export(output_path, format="ogg")
            
            # Check file sizes
            input_size = os.path.getsize(input_path) / 1024  # KB
            output_size = os.path.getsize(output_path) / 1024  # KB
            compression = ((input_size - output_size) / input_size) * 100
            
            print(f"   ✅ {output_filename} created ({output_size:.1f}KB, {compression:.1f}% compression)")
            converted_files.append(output_filename)
            
        except Exception as e:
            print(f"   ❌ Failed to convert {wav_file}: {e}")
    
    print(f"\n🎉 Converted {len(converted_files)} audio files!")
    print(f"📂 Web-compatible audio files in: {output_dir}")
    return len(converted_files) > 0

def main():
    """Main conversion function"""
    print("🎮 FlappyBird Audio Converter")
    print("=" * 40)
    
    # Convert original sounds to web format
    sounds_dir = "sounds"
    web_sounds_dir = "code/sounds_web"
    
    success = convert_wav_to_ogg(sounds_dir, web_sounds_dir)
    
    if success:
        print("\n📋 Next steps:")
        print("   1. Audio files converted to OGG format")
        print("   2. Web-compatible files created in code/sounds_web/")
        print("   3. Ready for pygbag web deployment!")
    else:
        print("\n❌ Audio conversion failed!")

if __name__ == "__main__":
    main()