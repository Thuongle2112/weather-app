import 'package:flutter/material.dart';

import 'animation_cache_service.dart';

/// Service to preload critical animations during app startup
class AnimationPreloader {
  static final AnimationPreloader _instance = AnimationPreloader._internal();
  factory AnimationPreloader() => _instance;
  AnimationPreloader._internal();

  final _animationCache = AnimationCacheService();
  bool _isPreloaded = false;

  /// Critical animations to load immediately
  static const List<String> criticalAnimations = [
    'assets/animations/new_year_splash_screen.json',
    'assets/animations/new_year_loading.json',
  ];

  /// Secondary animations to load after critical ones
  static const List<String> secondaryAnimations = [
    'assets/animations/new_year_floating_button.json',
    'assets/animations/no_internet_connection.json',
    'assets/animations/new_year_shake_effect.json',
  ];

  /// Optional animations to load when idle
  static const List<String> optionalAnimations = [
    'assets/animations/money_rain.json',
    'assets/animations/new_year_message.json',
    'assets/animations/lunar_year_button_drawer.json',
  ];

  /// Preload critical animations (blocking)
  Future<void> preloadCritical() async {
    if (_isPreloaded) return;

    debugPrint('🎬 Preloading critical animations...');
    final startTime = DateTime.now();

    await _animationCache.preloadBatch(criticalAnimations);

    final duration = DateTime.now().difference(startTime);
    debugPrint('✅ Critical animations preloaded in ${duration.inMilliseconds}ms');
  }

  /// Preload secondary animations (non-blocking, can be done after app start)
  Future<void> preloadSecondary() async {
    debugPrint('🎬 Preloading secondary animations...');
    final startTime = DateTime.now();

    await _animationCache.preloadBatch(secondaryAnimations);

    final duration = DateTime.now().difference(startTime);
    debugPrint('✅ Secondary animations preloaded in ${duration.inMilliseconds}ms');
  }

  /// Preload optional animations (lowest priority)
  Future<void> preloadOptional() async {
    debugPrint('🎬 Preloading optional animations...');
    final startTime = DateTime.now();

    await _animationCache.preloadBatch(optionalAnimations);

    final duration = DateTime.now().difference(startTime);
    debugPrint('✅ Optional animations preloaded in ${duration.inMilliseconds}ms');
  }

  /// Preload all animations with priority
  Future<void> preloadAll() async {
    // Load critical first
    await preloadCritical();

    // Then load secondary and optional in parallel (non-blocking)
    Future.wait([
      preloadSecondary(),
      preloadOptional(),
    ], eagerError: false);

    _isPreloaded = true;
  }

  /// Preload animations in background after app is ready
  void preloadInBackground() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      preloadSecondary();
      
      // Load optional animations after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        preloadOptional();
      });
    });
  }

  bool get isPreloaded => _isPreloaded;
}
