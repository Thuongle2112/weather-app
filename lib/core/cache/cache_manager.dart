import 'package:flutter/material.dart';

/// Generic cache entry with expiry time
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration? ttl; // Time to live
  
  CacheEntry({
    required this.data,
    required this.timestamp,
    this.ttl,
  });
  
  /// Check if cache entry is expired
  bool get isExpired {
    if (ttl == null) return false;
    return DateTime.now().difference(timestamp) > ttl!;
  }
  
  /// Get age of cache entry
  Duration get age => DateTime.now().difference(timestamp);
  
  /// Get remaining time until expiry
  Duration? get timeUntilExpiry {
    if (ttl == null) return null;
    final timeToLive = ttl!;
    final remaining = timeToLive - age;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

/// Enhanced cache manager with expiry time support
class CacheManager<T> {
  final Map<String, CacheEntry<T>> _cache = {};
  final Duration? defaultTtl;
  final int? maxSize;
  
  CacheManager({
    this.defaultTtl,
    this.maxSize,
  });
  
  /// Set cache with optional TTL
  void set(String key, T value, {Duration? ttl}) {
    // Remove expired entries if cache is full
    if (maxSize != null && _cache.length >= maxSize!) {
      _removeExpiredEntries();
      
      // If still full, remove oldest entry
      if (_cache.length >= maxSize!) {
        _removeOldestEntry();
      }
    }
    
    final entry = CacheEntry(
      data: value,
      timestamp: DateTime.now(),
      ttl: ttl ?? defaultTtl,
    );
    
    _cache[key] = entry;
    
    final expiryInfo = entry.ttl != null 
        ? '(expires in ${entry.ttl!.inMinutes}m)' 
        : '(no expiry)';
    debugPrint('💾 [Cache] Set: $key $expiryInfo');
  }
  
  /// Get cache, returns null if expired or not found
  T? get(String key, {bool removeIfExpired = true}) {
    final entry = _cache[key];
    
    if (entry == null) {
      debugPrint('ℹ️ [Cache] Miss: $key (not found)');
      return null;
    }
    
    if (entry.isExpired) {
      debugPrint('⚠️ [Cache] Expired: $key (age: ${entry.age.inMinutes}m, ttl: ${entry.ttl?.inMinutes}m)');
      
      if (removeIfExpired) {
        _cache.remove(key);
      }
      
      return null;
    }
    
    final remainingTime = entry.timeUntilExpiry;
    final timeInfo = remainingTime != null 
        ? '(expires in ${remainingTime.inMinutes}m)' 
        : '(no expiry)';
    debugPrint('✅ [Cache] Hit: $key $timeInfo');
    
    return entry.data;
  }
  
  /// Check if key exists and is not expired
  bool has(String key) {
    final entry = _cache[key];
    return entry != null && !entry.isExpired;
  }
  
  /// Get cache age
  Duration? getAge(String key) {
    return _cache[key]?.age;
  }
  
  /// Get time until expiry
  Duration? getTimeUntilExpiry(String key) {
    return _cache[key]?.timeUntilExpiry;
  }
  
  /// Remove specific key
  void remove(String key) {
    _cache.remove(key);
    debugPrint('🗑️ [Cache] Removed: $key');
  }
  
  /// Clear all cache
  void clear() {
    final count = _cache.length;
    _cache.clear();
    debugPrint('🗑️ [Cache] Cleared all ($count entries)');
  }
  
  /// Remove all expired entries
  int removeExpiredEntries() {
    return _removeExpiredEntries();
  }
  
  int _removeExpiredEntries() {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();
    
    for (final key in expiredKeys) {
      _cache.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      debugPrint('🗑️ [Cache] Removed ${expiredKeys.length} expired entries');
    }
    
    return expiredKeys.length;
  }
  
  void _removeOldestEntry() {
    if (_cache.isEmpty) return;
    
    final oldestKey = _cache.entries
        .reduce((a, b) => a.value.timestamp.isBefore(b.value.timestamp) ? a : b)
        .key;
    
    _cache.remove(oldestKey);
    debugPrint('🗑️ [Cache] Removed oldest entry: $oldestKey');
  }
  
  /// Get cache statistics
  CacheStats getStats() {
    final now = DateTime.now();
    var totalSize = _cache.length;
    var expiredCount = 0;
    var validCount = 0;
    Duration totalAge = Duration.zero;
    
    for (final entry in _cache.values) {
      if (entry.isExpired) {
        expiredCount++;
      } else {
        validCount++;
      }
      totalAge += now.difference(entry.timestamp);
    }
    
    return CacheStats(
      totalEntries: totalSize,
      validEntries: validCount,
      expiredEntries: expiredCount,
      averageAge: totalSize > 0 
          ? Duration(milliseconds: totalAge.inMilliseconds ~/ totalSize)
          : Duration.zero,
    );
  }
  
  /// Print cache statistics
  void printStats() {
    final stats = getStats();
    debugPrint('📊 [Cache] Stats:');
    debugPrint('   • Total: ${stats.totalEntries}');
    debugPrint('   • Valid: ${stats.validEntries}');
    debugPrint('   • Expired: ${stats.expiredEntries}');
    debugPrint('   • Avg Age: ${stats.averageAge.inMinutes}m');
  }
}

/// Cache statistics
class CacheStats {
  final int totalEntries;
  final int validEntries;
  final int expiredEntries;
  final Duration averageAge;
  
  CacheStats({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
    required this.averageAge,
  });
}

/// Specialized cache managers for different data types

/// Animation cache with TTL
class AnimationCacheManager extends CacheManager<dynamic> {
  static final AnimationCacheManager _instance = AnimationCacheManager._internal();
  factory AnimationCacheManager() => _instance;
  
  AnimationCacheManager._internal() : super(
    defaultTtl: const Duration(hours: 24), // Animations valid for 24h
    maxSize: 50, // Max 50 animations
  );
}

/// API response cache with TTL
class ApiCacheManager extends CacheManager<Map<String, dynamic>> {
  static final ApiCacheManager _instance = ApiCacheManager._internal();
  factory ApiCacheManager() => _instance;
  
  ApiCacheManager._internal() : super(
    defaultTtl: const Duration(minutes: 15), // API data valid for 15 minutes
    maxSize: 100, // Max 100 API responses
  );
}

/// Image cache with TTL
class ImageCacheManager extends CacheManager<String> {
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  factory ImageCacheManager() => _instance;
  
  ImageCacheManager._internal() : super(
    defaultTtl: const Duration(days: 7), // Images valid for 7 days
    maxSize: 200, // Max 200 images
  );
}

/// Translation cache with TTL
class TranslationCacheManager extends CacheManager<Map<String, dynamic>> {
  static final TranslationCacheManager _instance = TranslationCacheManager._internal();
  factory TranslationCacheManager() => _instance;
  
  TranslationCacheManager._internal() : super(
    defaultTtl: null, // Translations never expire
    maxSize: 20, // Max 20 locales
  );
}
