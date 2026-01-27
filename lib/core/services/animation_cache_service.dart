import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';

/// Cache entry with expiry time
class _AnimationCacheEntry {
  final Future<LottieComposition> composition;
  final DateTime timestamp;
  final Duration ttl;
  
  _AnimationCacheEntry({
    required this.composition,
    required this.timestamp,
    this.ttl = const Duration(hours: 24),
  });
  
  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
  Duration get age => DateTime.now().difference(timestamp);
}

/// Service for lazy loading and caching Lottie animations with expiry
class AnimationCacheService {
  static final AnimationCacheService _instance = AnimationCacheService._internal();
  factory AnimationCacheService() => _instance;
  AnimationCacheService._internal();

  final Map<String, _AnimationCacheEntry> _cache = {};
  final Duration defaultTtl = const Duration(hours: 24);
  final int maxCacheSize = 50;

  /// Preload an animation into cache
  Future<LottieComposition> preload(String assetPath, {Duration? ttl}) async {
    // Check if cached and not expired
    final entry = _cache[assetPath];
    if (entry != null && !entry.isExpired) {
      debugPrint('✅ Using cached animation: $assetPath (age: ${entry.age.inMinutes}m)');
      return entry.composition;
    }
    
    // Remove expired entry if exists
    if (entry != null && entry.isExpired) {
      debugPrint('⚠️ Expired animation removed: $assetPath (age: ${entry.age.inHours}h)');
      _cache.remove(assetPath);
    }
    
    // Cleanup if cache is full
    if (_cache.length >= maxCacheSize) {
      _removeOldestEntry();
    }

    final future = AssetLottie(assetPath).load();
    final cacheEntry = _AnimationCacheEntry(
      composition: future,
      timestamp: DateTime.now(),
      ttl: ttl ?? defaultTtl,
    );
    _cache[assetPath] = cacheEntry;

    try {
      final composition = await future;
      debugPrint('✅ Preloaded animation: $assetPath (ttl: ${cacheEntry.ttl.inHours}h)');
      return composition;
    } catch (e) {
      debugPrint('❌ Failed to preload animation: $assetPath - $e');
      _cache.remove(assetPath);
      rethrow;
    }
  }

  /// Preload multiple animations at once
  Future<void> preloadBatch(List<String> assetPaths) async {
    await Future.wait(
      assetPaths.map((path) => preload(path)),
      eagerError: false,
    );
  }

  /// Get cached animation or load if not cached
  Future<LottieComposition> get(String assetPath) async {
    final entry = _cache[assetPath];
    
    if (entry != null && !entry.isExpired) {
      return entry.composition;
    }
    
    return preload(assetPath);
  }

  /// Check if animation is cached and not expired
  bool isCached(String assetPath) {
    final entry = _cache[assetPath];
    return entry != null && !entry.isExpired;
  }

  /// Clear all cached animations
  void clearCache() {
    final count = _cache.length;
    _cache.clear();
    debugPrint('🗑️ Animation cache cleared ($count entries)');
  }

  /// Clear specific animation from cache
  void remove(String assetPath) {
    _cache.remove(assetPath);
    debugPrint('🗑️ Removed animation: $assetPath');
  }
  
  /// Remove all expired entries
  int removeExpiredEntries() {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredKeys) {
      _cache.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      debugPrint('🗑️ Removed ${expiredKeys.length} expired animations');
    }
    
    return expiredKeys.length;
  }
  
  void _removeOldestEntry() {
    if (_cache.isEmpty) return;
    
    final oldestKey = _cache.entries
        .reduce((a, b) => 
            a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
        .key;
    
    _cache.remove(oldestKey);
    debugPrint('🗑️ Removed oldest animation: $oldestKey');
  }
  
  /// Get cache statistics
  Map<String, dynamic> getStats() {
    final now = DateTime.now();
    var validCount = 0;
    var expiredCount = 0;
    Duration totalAge = Duration.zero;
    
    for (final entry in _cache.values) {
      if (entry.isExpired) {
        expiredCount++;
      } else {
        validCount++;
      }
      totalAge += now.difference(entry.timestamp);
    }
    
    return {
      'total': _cache.length,
      'valid': validCount,
      'expired': expiredCount,
      'averageAge': _cache.isNotEmpty 
          ? Duration(milliseconds: totalAge.inMilliseconds ~/ _cache.length)
          : Duration.zero,
    };
  }
  
  /// Print cache statistics
  void printStats() {
    final stats = getStats();
    debugPrint('📊 Animation Cache Stats:');
    debugPrint('   • Total: ${stats['total']}');
    debugPrint('   • Valid: ${stats['valid']}');
    debugPrint('   • Expired: ${stats['expired']}');
    debugPrint('   • Avg Age: ${(stats['averageAge'] as Duration).inMinutes}m');
  }
  
  /// Get cache size
  int get cacheSize => _cache.length;
}
