# Audio Assets cho Fortune Shake

## Files cần thêm:

### 1. fortune_background.mp3
- **Mô tả**: Nhạc nền Tết truyền thống (instrumental)
- **Thời lượng**: 1-2 phút (loop)
- **Nguồn gợi ý**:
  - Tìm "traditional chinese new year music instrumental" trên YouTube Audio Library
  - Hoặc "lunar new year background music"
  - Chọn bản không lời, nhẹ nhàng

### 2. shake_sound.mp3
- **Mô tả**: Âm thanh lắc lục (rattle/shake sound)
- **Thời lượng**: 0.5-1 giây
- **Nguồn gợi ý**:
  - Freesound.org: "bamboo shake"
  - Zapsplat.com: "wooden rattle"
  - Soundbible.com: "shake sound effect"

### 3. reveal_sound.mp3
- **Mô tả**: Âm thanh khi que xuất hiện (magical reveal)
- **Thời lượng**: 1-2 giây
- **Nguồn gợi ý**:
  - "magic spell sound effect"
  - "sparkle sound effect"
  - "chime sound effect"

## Hướng dẫn thêm audio:

1. **Download audio files** từ các nguồn free:
   - [YouTube Audio Library](https://studio.youtube.com/channel/UC/music)
   - [Freesound.org](https://freesound.org)
   - [Zapsplat.com](https://www.zapsplat.com)
   - [Mixkit.co](https://mixkit.co/free-sound-effects/)

2. **Convert sang MP3** (nếu cần):
   ```bash
   ffmpeg -i input.wav -acodec mp3 -ab 128k output.mp3
   ```

3. **Đặt files vào thư mục này**:
   ```
   assets/audio/
   ├── fortune_background.mp3
   ├── shake_sound.mp3
   └── reveal_sound.mp3
   ```

4. **Reload assets**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## Test audio:

Sau khi thêm files:
1. Chạy app
2. Vào màn Fortune Shake
3. Nghe nhạc nền tự động play
4. Chạm vào lọ → Nghe shake sound
5. Que xuất hiện → Nghe reveal sound

## Temporary workaround (nếu chưa có audio):

Code đã có try-catch, nên app vẫn chạy bình thường dù chưa có audio files. 
Chỉ hiện debug message trong console.
