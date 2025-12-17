# Weather Today (Ứng dụng thời tiết)

Ứng dụng Weather Today cung cấp thông tin thời tiết nhanh, trực quan và dự báo chi tiết cho vị trí của bạn. Ứng dụng đã được phát hành trên Google Play Store: https://play.google.com/store/apps/details?id=com.zamoon6.weather_today&pcampaignid=web_share

---

Weather Today provides fast, clear weather information and detailed forecasts for your current location. The app is published on Google Play Store: https://play.google.com/store/apps/details?id=com.zamoon6.weather_today&pcampaignid=web_share

Features include current conditions, hourly/daily forecasts, multi-language support (9+ languages), location-based weather, and beautiful weather animations.

See the Vietnamese sections below for full developer and build instructions.

---

## Tổng quan / Overview

- Tên / Name: Weather Today
- Package (Play Store): `com.zamoon6.weather_today`
- Link cửa hàng / Store link: https://play.google.com/store/apps/details?id=com.zamoon6.weather_today&pcampaignid=web_share

Ứng dụng hiển thị nhiệt độ hiện tại, dự báo theo giờ/5 ngày, thông tin gió, độ ẩm và biểu tượng thời tiết SVG 3D sinh động. Hỗ trợ 9+ ngôn ngữ và tích hợp định vị để lấy dữ liệu cho vị trí hiện tại với khả năng tìm kiếm thành phố toàn cầu.

The app shows current temperature, hourly/5-day forecasts, wind, humidity, and lively 3D SVG weather icons. Supports 9+ languages and integrates location services to fetch weather for the current position with global city search capability.

## Tính năng chính / Key Features

### 🌤️ Thông tin thời tiết chi tiết / Detailed Weather Information
- **Nhiệt độ hiện tại**: Nhiệt độ thực tế, cảm giác như, min/max trong ngày
- **Các chỉ số**: Độ ẩm, áp suất khí quyển, tốc độ gió, tầm nhìn
- **Mô tả thời tiết**: Hiển thị chi tiết tình trạng thời tiết bằng ngôn ngữ địa phương

- **Current Temperature**: Real temperature, feels-like, daily min/max
- **Metrics**: Humidity, atmospheric pressure, wind speed, visibility
- **Weather Description**: Detailed weather conditions in local language

### 📊 Dự báo thời tiết / Weather Forecasts
- **Dự báo theo giờ**: Dự báo 24 giờ tiếp theo (3-hour intervals)
- **Dự báo 5 ngày**: Thông tin chi tiết cho 5 ngày tới với nhiệt độ min/max
- **Biểu đồ nhiệt độ**: Visualize temperature trends
- **Icon động**: 35+ biểu tượng thời tiết 3D SVG

- **Hourly Forecast**: Next 24 hours (3-hour intervals)
- **5-Day Forecast**: Detailed information for next 5 days with min/max temps
- **Temperature Charts**: Visualize temperature trends
- **Dynamic Icons**: 35+ 3D SVG weather icons

### 🌍 Đa ngôn ngữ / Multi-language Support
Hỗ trợ 9+ ngôn ngữ với localization đầy đủ:
- 🇺🇸 English (Tiếng Anh)
- 🇻🇳 Vietnamese (Tiếng Việt)
- 🇯🇵 Japanese (日本語)
- 🇰🇷 Korean (한국어)
- 🇨🇳 Chinese (中文)
- 🇹🇭 Thai (ภาษาไทย)
- 🇫🇷 French (Français)
- 🇩🇪 German (Deutsch)
- 🇪🇸 Spanish (Español)

**Tên thành phố địa phương hóa**: Hiển thị tên thành phố theo ngôn ngữ người dùng
- VD: "東京" (Nhật), "서울" (Hàn), "Hà Nội" (Việt), "Bangkok" (กรุงเทพฯ Thai)

Supports 9+ languages with full localization including localized city names.

### 📍 Định vị thông minh / Smart Location
- **Auto-detect**: Tự động phát hiện vị trí hiện tại
- **Tìm kiếm thành phố**: Tìm kiếm toàn cầu với 50+ thành phố phổ biến
- **Tìm kiếm đa ngôn ngữ**: Tìm bằng cả tiếng Anh và tiếng địa phương
- **Popular Cities**: Danh sách thành phố được tối ưu theo khu vực

- **Auto-detect**: Automatically detect current location
- **City Search**: Global search with 50+ popular cities
- **Multi-language Search**: Search in both English and local language
- **Popular Cities**: Region-optimized city list

### 🎨 Giao diện đẹp mắt / Beautiful UI
- **3D Weather Icons**: Hơn 35 icon SVG 3D chất lượng cao
- **Dynamic Backgrounds**: Hình nền thay đổi theo điều kiện thời tiết
- **Smooth Animations**: Hiệu ứng chuyển động mượt mà
- **Dark/Light Mode**: Chế độ tối/sáng tự động
- **Responsive Design**: Tối ưu cho mọi kích thước màn hình

- **3D Weather Icons**: 35+ high-quality SVG 3D icons
- **Dynamic Backgrounds**: Weather-based background changes
- **Smooth Animations**: Fluid transition effects
- **Dark/Light Mode**: Automatic theme switching
- **Responsive Design**: Optimized for all screen sizes

### 🎯 Tính năng đặc biệt / Special Features
- **Hiệu ứng sự kiện**: Halloween, Christmas, và các sự kiện đặc biệt
- **Shake to Refresh**: Lắc điện thoại để làm mới dữ liệu
- **Premium Features**: Không quảng cáo cho người dùng Premium
- **Time Progress Bar**: Hiển thị tiến trình trong ngày (sunrise, noon, sunset, moonrise)
- **City Cards**: Cards hiển thị nhiệt độ các thành phố phổ biến

- **Event Effects**: Halloween, Christmas, and special event animations
- **Shake to Refresh**: Shake phone to refresh weather data
- **Premium Features**: Ad-free experience for premium users
- **Time Progress Bar**: Daily progress (sunrise, noon, sunset, moonrise)
- **City Cards**: Cards showing popular cities' temperatures

### 🔔 Thông báo / Notifications
- Thông báo thời tiết định kỳ
- Cảnh báo thời tiết khắc nghiệt
- Tùy chỉnh tần suất thông báo

- Periodic weather notifications
- Severe weather alerts
- Customizable notification frequency

## Công nghệ / Technology Stack

### Framework & Language
- **Flutter** 3.24.5+ (Dart)
- **Clean Architecture** với BLoC pattern
- **Dependency Injection** với GetIt

### State Management
- **flutter_bloc** ^8.1.6 - Business Logic Component
- **Provider** ^6.1.2 - Simple state management
- **Equatable** ^2.0.7 - Value equality

### API & Data
- **OpenWeather API** - Weather data source
  - Current Weather API
  - 5-Day/3-Hour Forecast API
  - Multi-language support
- **dio** ^5.7.0 - HTTP client
- **shared_preferences** ^2.3.3 - Local storage

### Location Services
- **geolocator** ^13.0.2 - GPS positioning
- **permission_handler** ^11.3.1 - Runtime permissions

### UI & Animations
- **flutter_svg** ^2.0.10+1 - SVG rendering (35+ weather icons)
- **lottie** ^3.1.3 - JSON animations
- **flutter_screenutil** ^5.9.3 - Responsive design
- **shimmer** ^3.0.0 - Loading effects

### Localization
- **easy_localization** ^3.0.7 - Multi-language support
- **intl** ^0.19.0 - Date/time formatting

### Firebase Services
- **firebase_core** ^3.6.0
- **firebase_messaging** ^15.1.3 - Push notifications
- **firebase_analytics** ^11.3.3 - Analytics

### Monetization
- **google_mobile_ads** ^5.2.0 - AdMob integration
- Banner ads, Interstitial ads, Rewarded ads

### Development Tools
- **flutter_dotenv** ^5.2.1 - Environment variables
- **flutter_launcher_icons** ^0.14.1 - App icon generation

## Architecture

```
lib/
├── core/                    # Core utilities & services
│   ├── services/           # Ad service, location service
│   └── utils/              # Constants, helpers
├── data/                   # Data layer
│   ├── datasource/        # API data sources
│   ├── model/             # Data models
│   └── repository/        # Repository implementations
├── domain/                 # Domain layer
│   ├── repository/        # Repository interfaces
│   └── usecase/           # Business logic use cases
└── presentation/          # Presentation layer
    ├── page/             # UI screens
    ├── widgets/          # Reusable widgets
    ├── bloc/             # BLoC state management
    └── utils/            # UI helpers, mappers
```

### Design Patterns
- **Repository Pattern**: Abstraction cho data sources
- **BLoC Pattern**: Separation of business logic và UI
- **Use Case Pattern**: Single responsibility principle
- **Dependency Injection**: Loose coupling
- **Clean Architecture**: Maintainable & testable code

## Yêu cầu môi trường phát triển / Development Requirements

### Required
- **Flutter SDK** ≥3.5.4 <4.0.0
- **Dart SDK** ≥3.5.4 <4.0.0
- **Android SDK** (for Android builds)
  - minSdkVersion: 21
  - targetSdkVersion: 34
- **macOS** (development tested on macOS)

### Optional
- **Xcode** (for iOS builds)
- **Android Studio** / **VS Code** with Flutter extensions
- **Git** for version control

### API Keys Required
Create `.env` file in project root:
```env
OPENWEATHER_API_KEY=your_api_key_here
ADMOB_APP_ID_ANDROID=your_admob_app_id
ADMOB_BANNER_UNIT_ID_ANDROID=your_banner_id
ADMOB_INTERSTITIAL_UNIT_ID_ANDROID=your_interstitial_id
ADMOB_REWARDED_UNIT_ID_ANDROID=your_rewarded_id
```

## Chạy ứng dụng (phát triển) / Run (Development)

1. **Clone repository**:
```bash
git clone <repo-url>
cd weather-app
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Setup environment**:
```bash
# Copy .env.example to .env and fill in your API keys
cp .env.example .env
```

4. **Run on emulator or device**:
```bash
# Run in debug mode
flutter run

# Run with specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

5. **Hot reload**: Press `r` in terminal or use IDE hot reload

**Note**: Enable location permissions on emulator/device when testing location features.

## Build Release cho Android (APK / AAB) / Android Release Build

### 1. Setup Signing Key

If you don't have a signing key:
```bash
keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
```

Create `android/key.properties`:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=my-key-alias
storeFile=<path-to-your-keystore>
```

### 2. Build APK
```bash
# Build release APK
flutter build apk --release

# Build APK for specific ABI (smaller size)
flutter build apk --target-platform android-arm64 --release
```

### 3. Build App Bundle (AAB) for Play Store
```bash
flutter build appbundle --release
```

### 4. Output Files
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

**Security Note**: Keep `key.properties` and `.jks` files secure. Never commit them to public repositories.

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze
```

## Quyền truy cập (Permissions) / Permissions

### Android (`AndroidManifest.xml`)
```xml
<!-- Required -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<!-- Optional -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

### iOS (`Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to provide weather for your area</string>
```

## Localization (Đa ngôn ngữ) / Localization

### Structure
```
assets/translations/
├── en.json          # English
├── vi.json          # Vietnamese
├── ja.json          # Japanese
├── ko.json          # Korean
├── zh.json          # Chinese
├── th.json          # Thai
├── fr.json          # French
├── de.json          # German
└── es.json          # Spanish
```

### Adding New Language
1. Create `assets/translations/{locale}.json`
2. Add translations following existing structure
3. Update `EasyLocalization` supported locales in `main.dart`

### City Name Localization
City names are automatically localized using `CityLocalizationHelper`:
- Display: Local language (e.g., "東京" for Tokyo in Japanese)
- API calls: Always use English names

## Weather Icons

### 35+ 3D SVG Icons
Located in `assets/weather_icons/`:
- Clear sky: `3D Ico_01.svg`
- Clouds: `3D Ico_04.svg`, `3D Ico_13.svg`
- Rain: `3D Ico_07.svg`, `3D Ico_17.svg`
- Snow: `3D Ico_05.svg`, `3D Ico_20.svg`, `3D Ico_27.svg`
- Fog: `3D Ico_32.svg`
- And more...

### Icon Mapping
`WeatherIconMapper` handles multi-language weather descriptions:
- English: "clear sky" → `3D Ico_01.svg`
- Vietnamese: "trời quang đãng" → `3D Ico_01.svg`
- Japanese: "晴天" → `3D Ico_01.svg`
- Supports 9+ languages with smart keyword matching

## Play Store

### Current Release
- **Package**: `com.zamoon6.weather_today`
- **Version**: Check `pubspec.yaml` for current version
- **Link**: https://play.google.com/store/apps/details?id=com.zamoon6.weather_today&pcampaignid=web_share

### Publishing Updates
1. Update version in `pubspec.yaml`
2. Build AAB: `flutter build appbundle --release`
3. Upload to Google Play Console
4. Fill in release notes
5. Submit for review

## Quyền riêng tư và dữ liệu / Privacy & Data

### Data Collection
Ứng dụng thu thập và sử dụng:
- **Location Data**: Chỉ khi được phép, để lấy thông tin thời tiết cho vị trí hiện tại
- **Device ID**: Cho mục đích analytics và ads (nếu không Premium)
- **Usage Data**: Thống kê sử dụng app qua Firebase Analytics

The app collects and uses:
- **Location Data**: Only when permitted, to fetch local weather
- **Device ID**: For analytics and ads (if not Premium)
- **Usage Data**: App usage statistics via Firebase Analytics

### Data Sharing
- Không bán hoặc chia sẻ dữ liệu cá nhân cho bên thứ ba
- Dữ liệu được mã hóa trong quá trình truyền tải
- Tuân thủ GDPR và các quy định về quyền riêng tư

- No selling or sharing of personal data to third parties
- Data encrypted during transmission
- GDPR compliant

### Privacy Policy
[Add your Privacy Policy URL here]

## Known Issues & Limitations

- **Location**: Requires GPS/network location enabled
- **API Rate Limit**: OpenWeather free tier has rate limits
- **Offline**: App requires internet connection for weather data
- **iOS**: Not yet published on App Store (Android only for now)

## Roadmap / Upcoming Features

- [ ] Radar map visualization
- [ ] Weather widgets for home screen
- [ ] Apple Watch support
- [ ] Severe weather alerts push notifications
- [ ] Historical weather data
- [ ] Multiple location management
- [ ] iOS App Store release
- [ ] More weather parameters (UV index, air quality)
- [ ] Social sharing weather cards

## Ảnh màn hình / Screenshots

<div style="display: flex; overflow-x: auto; gap: 10px; padding: 10px 0;">
  <img src="assets/readme_screenshots/screen1.png" alt="Home1" width="200"/>
  <img src="assets/readme_screenshots/screen2.png" alt="Home2" width="200"/>
  <img src="assets/readme_screenshots/screen3.png" alt="Splash" width="200"/>
  <img src="assets/readme_screenshots/screen4.png" alt="Location" width="200"/>
  <img src="assets/readme_screenshots/screen5.png" alt="Hour-Daily" width="200"/>
  <img src="assets/readme_screenshots/screen6.png" alt="Locale" width="200"/>
</div>

## Đóng góp / Contributing

Chào mừng mọi đóng góp! / Contributions are welcome!

### Steps
1. **Fork repository**
2. **Create feature branch**: `git checkout -b feature/your-feature`
3. **Make changes** and commit: `git commit -m "Add: your feature"`
4. **Push to branch**: `git push origin feature/your-feature`
5. **Open Pull Request** with clear description

### Before PR
- Run `flutter analyze` - No errors
- Run `flutter test` - All tests pass
- Follow existing code style
- Update documentation if needed
- Test on both Android emulator and physical device

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use meaningful variable/function names
- Add comments for complex logic
- Keep functions small and focused

## FAQ / Câu hỏi thường gặp

### Q: App không lấy được vị trí?
**A**: Kiểm tra:
- Đã cấp quyền location trong Settings
- GPS/Location services đã bật
- Thử khởi động lại app

### Q: Tại sao thời tiết không cập nhật?
**A**: 
- Kiểm tra kết nối internet
- API key có thể đã hết hạn hoặc vượt giới hạn
- Thử pull to refresh hoặc shake device

### Q: Làm sao thêm thành phố yêu thích?
**A**: 
- Tap vào "Change Location" button
- Search và chọn thành phố
- City được tự động fetch

### Q: App có hỗ trợ offline không?
**A**: Không, app cần internet để lấy dữ liệu thời tiết mới nhất từ API.

### Q: Tại sao có quảng cáo?
**A**: Quảng cáo giúp duy trì app miễn phí. Bạn có thể nâng cấp Premium để tắt quảng cáo.

## Troubleshooting

### Build Errors
```bash
# Clean build
flutter clean
flutter pub get
flutter build apk --release
```

### Location Issues
- Check permissions in device Settings
- Ensure GPS is enabled
- Try on physical device (emulator GPS may be unreliable)

### API Issues
- Verify API key in `.env`
- Check OpenWeather API dashboard for quota
- Ensure internet connection is stable

## Performance Tips

- **Image Caching**: Weather icons are cached automatically
- **API Calls**: Data refreshes every 10 minutes to save quota
- **Memory**: SVG icons are lightweight
- **Battery**: Location updates are optimized

## License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2024 Weather Today

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Credits & Acknowledgments

### APIs & Services
- [OpenWeather API](https://openweathermap.org/) - Weather data provider
- [Firebase](https://firebase.google.com/) - Backend services
- [AdMob](https://admob.google.com/) - Monetization

### Assets
- Weather Icons: 3D SVG icons from custom design
- Animations: Lottie animations
- Background Images: Custom weather backgrounds

### Libraries
Special thanks to all Flutter package maintainers.

## Liên hệ / Contact

- **Developer**: Thuongle2112
- **Email**: 667715koco@gmail.com
- **GitHub**: https://github.com/Thuongle2112
- **Play Store**: https://play.google.com/store/apps/details?id=com.zamoon6.weather_today&pcampaignid=web_share
<!-- - **Issues**: [GitHub Issues](https://github.com/your-repo/issues) -->

## Support

If you like this project:
- ⭐ Star this repository
- 🐛 Report bugs via Issues
- 💡 Suggest features
- 📢 Share with friends
<!-- - ☕ [Buy me a coffee](your-coffee-link) -->

---

## Getting Started (Official Flutter Resources)

For help getting started with Flutter development, view the
[official documentation](https://docs.flutter.dev/) which offers tutorials,
samples, and a full API reference.

### Useful Resources
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter API Documentation](https://api.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

---

**Made with ❤️ by Thuongle2112**