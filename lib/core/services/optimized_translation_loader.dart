import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Optimized translation loader that only loads current locale instead of all locales
/// This significantly improves app startup time by reducing I/O operations
class OptimizedTranslationLoader extends AssetLoader {
  const OptimizedTranslationLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final localePath = '$path/${locale.languageCode}.json';
    
    debugPrint('🌍 [Translation] Loading locale: ${locale.languageCode}');
    final startTime = DateTime.now();
    
    try {
      final jsonString = await rootBundle.loadString(localePath);
      final data = json.decode(jsonString) as Map<String, dynamic>;
      
      final duration = DateTime.now().difference(startTime);
      debugPrint('✅ [Translation] Loaded ${locale.languageCode} in ${duration.inMilliseconds}ms');
      
      return data;
    } catch (e) {
      debugPrint('❌ [Translation] Failed to load ${locale.languageCode}: $e');
      rethrow;
    }
  }
}
