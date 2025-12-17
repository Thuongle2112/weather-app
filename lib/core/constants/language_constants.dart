import 'package:flutter/material.dart';

class LanguageConstants {
  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      countryCode: 'US',
      flag: '🇺🇸',
    ),
    LanguageModel(
      code: 'vi',
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      countryCode: 'VN',
      flag: '🇻🇳',
    ),
    LanguageModel(
      code: 'ja',
      name: 'Japanese',
      nativeName: '日本語',
      countryCode: 'JP',
      flag: '🇯🇵',
    ),
    LanguageModel(
      code: 'ko',
      name: 'Korean',
      nativeName: '한국어',
      countryCode: 'KR',
      flag: '🇰🇷',
    ),
    LanguageModel(
      code: 'zh',
      name: 'Chinese',
      nativeName: '中文',
      countryCode: 'CN',
      flag: '🇨🇳',
    ),
    LanguageModel(
      code: 'th',
      name: 'Thai',
      nativeName: 'ภาษาไทย',
      countryCode: 'TH',
      flag: '🇹🇭',
    ),
    LanguageModel(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      countryCode: 'FR',
      flag: '🇫🇷',
    ),
    LanguageModel(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
      countryCode: 'DE',
      flag: '🇩🇪',
    ),
    LanguageModel(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      countryCode: 'ES',
      flag: '🇪🇸',
    ),
  ];

  static LanguageModel getLanguageByCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supportedLanguages[0],
    );
  }

  static List<Locale> get supportedLocales {
    return supportedLanguages.map((lang) => Locale(lang.code)).toList();
  }
}

class LanguageModel {
  final String code;
  final String name;
  final String nativeName;
  final String countryCode;
  final String flag;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.countryCode,
    required this.flag,
  });
}
