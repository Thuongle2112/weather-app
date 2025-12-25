# Weather Today

Ứng dụng thời tiết nhanh, trực quan, hỗ trợ đa ngôn ngữ và dự báo chi tiết cho vị trí của bạn.

[Google Play Store](https://play.google.com/store/apps/details?id=com.zamoon6.weather_today&pcampaignid=web_share)

---

## Tính năng chính

- Hiển thị nhiệt độ, độ ẩm, gió, mô tả thời tiết
- Dự báo theo giờ & 5 ngày
- Đa ngôn ngữ (9+ ngôn ngữ, tên thành phố địa phương hóa)
- Định vị tự động, tìm kiếm thành phố toàn cầu
- Giao diện đẹp, icon thời tiết 3D SVG, nền động, dark/light mode
- Thông báo thời tiết, cảnh báo khắc nghiệt
- Không quảng cáo cho người dùng Premium

---

## Công nghệ

- **Flutter** 3.24.5+ (Dart)
- **BLoC, Provider, Clean Architecture**
- **OpenWeather API**
- **Firebase, AdMob**
- **easy_localization, flutter_svg, lottie**

---

## Cài đặt & chạy thử

```bash
git clone <repo-url>
cd weather-app
flutter pub get
cp .env.example .env
flutter run
```

---

## Build APK/AAB

```bash
flutter build apk --release
flutter build appbundle --release
```

---

## Testing

```bash
flutter test
flutter analyze
```

---

## Quyền truy cập

- Android: INTERNET, ACCESS_FINE_LOCATION
- iOS: NSLocationWhenInUseUsageDescription

---

## Đóng góp

- Fork, tạo branch, PR
- Chạy `flutter analyze` và `flutter test` trước khi gửi PR

---

## Liên hệ

- **Developer**: Thuongle2112
- **Email**: 667715koco@gmail.com
- **GitHub**: https://github.com/Thuongle2112

---

**Made with ❤️ by Thuongle2112**