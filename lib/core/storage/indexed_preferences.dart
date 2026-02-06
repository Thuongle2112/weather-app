import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Indexed SharedPreferences manager for fast key lookups
/// Uses structured key prefixes and in-memory index for O(1) access
class IndexedPreferences {
  final SharedPreferences _prefs;
  
  // In-memory index for fast key lookups
  final Map<String, Set<String>> _keyIndex = {};
  bool _isIndexed = false;
  
  IndexedPreferences(this._prefs);
  
  /// Key prefixes for structured organization
  static const String prefixWeather = 'weather:';
  static const String prefixForecast = 'forecast:';
  static const String prefixCache = 'cache:';
  static const String prefixUser = 'user:';
  static const String prefixSettings = 'settings:';
  static const String prefixNotification = 'notification:';
  static const String prefixLanguage = 'language:';
  static const String prefixTheme = 'theme:';
  static const String prefixLocation = 'location:';
  
  /// Initialize index from existing keys
  Future<void> buildIndex() async {
    if (_isIndexed) return;
    
    final startTime = DateTime.now();
    debugPrint('🔍 [Index] Building SharedPreferences index...');
    
    final allKeys = _prefs.getKeys();
    
    for (final key in allKeys) {
      final prefix = _extractPrefix(key);
      _keyIndex.putIfAbsent(prefix, () => {}).add(key);
    }
    
    final duration = DateTime.now().difference(startTime);
    debugPrint('✅ [Index] Built index for ${allKeys.length} keys in ${duration.inMilliseconds}ms');
    debugPrint('📊 [Index] Prefixes: ${_keyIndex.keys.join(", ")}');
    
    _isIndexed = true;
  }
  
  /// Extract prefix from key
  String _extractPrefix(String key) {
    final colonIndex = key.indexOf(':');
    if (colonIndex == -1) return 'other';
    return key.substring(0, colonIndex + 1);
  }
  
  /// Get all keys with specific prefix (O(1) with index)
  Set<String> getKeysByPrefix(String prefix) {
    if (!_isIndexed) {
      debugPrint('⚠️ [Index] Not indexed yet, building now...');
      buildIndex();
    }
    return _keyIndex[prefix] ?? {};
  }
  
  /// Set with automatic index update
  Future<bool> setString(String key, String value) async {
    final result = await _prefs.setString(key, value);
    if (result) {
      _addToIndex(key);
      debugPrint('💾 [Index] Set: $key');
    }
    return result;
  }
  
  Future<bool> setInt(String key, int value) async {
    final result = await _prefs.setInt(key, value);
    if (result) _addToIndex(key);
    return result;
  }
  
  Future<bool> setBool(String key, bool value) async {
    final result = await _prefs.setBool(key, value);
    if (result) _addToIndex(key);
    return result;
  }
  
  Future<bool> setDouble(String key, double value) async {
    final result = await _prefs.setDouble(key, value);
    if (result) _addToIndex(key);
    return result;
  }
  
  Future<bool> setStringList(String key, List<String> value) async {
    final result = await _prefs.setStringList(key, value);
    if (result) _addToIndex(key);
    return result;
  }
  
  /// Get with type safety
  String? getString(String key) => _prefs.getString(key);
  int? getInt(String key) => _prefs.getInt(key);
  bool? getBool(String key) => _prefs.getBool(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);
  
  /// Remove with automatic index update
  Future<bool> remove(String key) async {
    final result = await _prefs.remove(key);
    if (result) {
      _removeFromIndex(key);
      debugPrint('🗑️ [Index] Removed: $key');
    }
    return result;
  }
  
  /// Remove all keys with prefix (efficient bulk delete)
  Future<int> removeByPrefix(String prefix) async {
    final keys = getKeysByPrefix(prefix);
    var removedCount = 0;
    
    for (final key in keys) {
      if (await _prefs.remove(key)) {
        removedCount++;
      }
    }
    
    _keyIndex.remove(prefix);
    debugPrint('🗑️ [Index] Removed $removedCount keys with prefix: $prefix');
    
    return removedCount;
  }
  
  /// Clear all data
  Future<bool> clear() async {
    final result = await _prefs.clear();
    if (result) {
      _keyIndex.clear();
      _isIndexed = false;
      debugPrint('🗑️ [Index] Cleared all data');
    }
    return result;
  }
  
  /// Add key to index
  void _addToIndex(String key) {
    final prefix = _extractPrefix(key);
    _keyIndex.putIfAbsent(prefix, () => {}).add(key);
  }
  
  /// Remove key from index
  void _removeFromIndex(String key) {
    final prefix = _extractPrefix(key);
    _keyIndex[prefix]?.remove(key);
    
    // Remove empty prefix set
    if (_keyIndex[prefix]?.isEmpty ?? false) {
      _keyIndex.remove(prefix);
    }
  }
  
  /// Search keys by pattern (regex supported)
  Set<String> searchKeys(String pattern, {bool useRegex = false}) {
    final allKeys = _prefs.getKeys();
    
    if (useRegex) {
      final regex = RegExp(pattern);
      return allKeys.where((key) => regex.hasMatch(key)).toSet();
    }
    
    return allKeys.where((key) => key.contains(pattern)).toSet();
  }
  
  /// Get statistics
  Map<String, dynamic> getStats() {
    final stats = <String, dynamic>{};
    
    for (final entry in _keyIndex.entries) {
      stats[entry.key] = entry.value.length;
    }
    
    stats['total'] = _prefs.getKeys().length;
    stats['indexed'] = _isIndexed;
    
    return stats;
  }
  
  /// Print statistics
  void printStats() {
    final stats = getStats();
    debugPrint('📊 [Index] SharedPreferences Stats:');
    debugPrint('   • Total keys: ${stats['total']}');
    debugPrint('   • Indexed: ${stats['indexed']}');
    
    for (final entry in stats.entries) {
      if (entry.key != 'total' && entry.key != 'indexed') {
        debugPrint('   • ${entry.key}: ${entry.value}');
      }
    }
  }
  
  /// Rebuild index (call after external modifications)
  Future<void> rebuildIndex() async {
    _keyIndex.clear();
    _isIndexed = false;
    await buildIndex();
  }
}

/// Helper class for building structured keys
class PreferenceKeys {
  // Weather keys
  static String weatherCurrent(String location) => 
      '${IndexedPreferences.prefixWeather}current:$location';
  
  static String weatherTimestamp(String location) => 
      '${IndexedPreferences.prefixWeather}timestamp:$location';
  
  // Forecast keys
  static String forecastHourly(String location) => 
      '${IndexedPreferences.prefixForecast}hourly:$location';
  
  static String forecastDaily(String location) => 
      '${IndexedPreferences.prefixForecast}daily:$location';
  
  static String forecastTimestamp(String location, String type) => 
      '${IndexedPreferences.prefixForecast}timestamp:$type:$location';
  
  // Cache keys
  static String cacheData(String type, String id) => 
      '${IndexedPreferences.prefixCache}$type:$id';
  
  static String cacheTimestamp(String type, String id) => 
      '${IndexedPreferences.prefixCache}timestamp:$type:$id';
  
  // User keys
  static String userSetting(String name) => 
      '${IndexedPreferences.prefixUser}setting:$name';
  
  static String userPreference(String name) => 
      '${IndexedPreferences.prefixUser}preference:$name';
  
  // Settings keys
  static String settingsValue(String key) => 
      '${IndexedPreferences.prefixSettings}$key';
  
  // Notification keys
  static String notificationEnabled(String type) => 
      '${IndexedPreferences.prefixNotification}enabled:$type';
  
  static String notificationTime(String type) => 
      '${IndexedPreferences.prefixNotification}time:$type';
  
  static String notificationCity(String city, String setting) => 
      '${IndexedPreferences.prefixNotification}city:$city:$setting';
  
  // Language keys
  static String languageCode() => '${IndexedPreferences.prefixLanguage}code';
  
  static String languageRegion() => '${IndexedPreferences.prefixLanguage}region';
  
  // Theme keys
  static String themeMode() => '${IndexedPreferences.prefixTheme}mode';
  
  static String themeDark() => '${IndexedPreferences.prefixTheme}dark';
  
  // Location keys
  static String locationLat() => '${IndexedPreferences.prefixLocation}lat';
  
  static String locationLon() => '${IndexedPreferences.prefixLocation}lon';
  
  static String locationName() => '${IndexedPreferences.prefixLocation}name';
}
