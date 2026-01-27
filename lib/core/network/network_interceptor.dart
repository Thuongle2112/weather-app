import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Network interceptor with retry logic and timeout handling
class NetworkInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final Duration timeout;
  
  NetworkInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.timeout = const Duration(seconds: 15),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Set timeout for each request
    options.connectTimeout = timeout;
    options.receiveTimeout = timeout;
    options.sendTimeout = timeout;
    
    debugPrint('🌐 [Network] Request: ${options.method} ${options.uri}');
    debugPrint('📊 [Network] Timeout: ${timeout.inSeconds}s | Max Retries: $maxRetries');
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ [Network] Response: ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('⏱️ [Network] Duration: ${response.requestOptions.extra['start_time'] != null ? DateTime.now().difference(response.requestOptions.extra['start_time'] as DateTime).inMilliseconds : '?'}ms');
    
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    
    // Get current retry count
    final retryCount = requestOptions.extra['retry_count'] as int? ?? 0;
    
    debugPrint('❌ [Network] Error: ${err.type} - ${err.message}');
    debugPrint('🔄 [Network] Retry attempt: $retryCount/$maxRetries');
    
    // Check if we should retry
    if (_shouldRetry(err) && retryCount < maxRetries) {
      requestOptions.extra['retry_count'] = retryCount + 1;
      
      // Calculate exponential backoff
      final delayMs = _calculateBackoff(retryCount);
      debugPrint('⏳ [Network] Waiting ${delayMs}ms before retry ${retryCount + 1}...');
      
      await Future.delayed(Duration(milliseconds: delayMs));
      
      try {
        debugPrint('🔁 [Network] Retrying request (${retryCount + 1}/$maxRetries)...');
        
        // Store start time for duration measurement
        requestOptions.extra['start_time'] = DateTime.now();
        
        // Retry the request
        final response = await Dio().fetch(requestOptions);
        
        debugPrint('✅ [Network] Retry successful after ${retryCount + 1} attempts');
        return handler.resolve(response);
      } catch (e) {
        debugPrint('❌ [Network] Retry failed: $e');
        
        // If this was the last retry, return original error
        if (retryCount + 1 >= maxRetries) {
          debugPrint('🚫 [Network] Max retries reached, failing request');
          return handler.next(err);
        }
        
        // Otherwise, recursively retry
        return onError(
          e is DioException ? e : DioException(requestOptions: requestOptions, error: e),
          handler,
        );
      }
    }
    
    debugPrint('🚫 [Network] Not retrying (type: ${err.type})');
    super.onError(err, handler);
  }

  /// Determine if the error should trigger a retry
  bool _shouldRetry(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        debugPrint('🔄 [Network] Retry reason: Timeout');
        return true;
        
      case DioExceptionType.connectionError:
        debugPrint('🔄 [Network] Retry reason: Connection error');
        return true;
        
      case DioExceptionType.unknown:
        // Retry on network errors
        debugPrint('🔄 [Network] Retry reason: Unknown error (likely network)');
        return true;
        
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        // Retry on 5xx server errors and 429 (rate limit)
        if (statusCode != null && (statusCode >= 500 || statusCode == 429)) {
          debugPrint('🔄 [Network] Retry reason: Server error ($statusCode)');
          return true;
        }
        return false;
        
      default:
        return false;
    }
  }

  /// Calculate exponential backoff with jitter
  int _calculateBackoff(int retryCount) {
    // Exponential backoff: 2^retryCount * base delay
    final exponentialDelay = retryDelay.inMilliseconds * (1 << retryCount);
    
    // Add jitter (±25% randomness) to avoid thundering herd
    final jitter = (exponentialDelay * 0.25 * (DateTime.now().millisecond % 100 / 100)).round();
    final finalDelay = exponentialDelay + jitter;
    
    // Cap at 30 seconds
    return finalDelay > 30000 ? 30000 : finalDelay;
  }
}

/// Enhanced Dio client factory with network optimization
class NetworkClient {
  static Dio create({
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    Duration timeout = const Duration(seconds: 15),
    bool enableLogging = true,
  }) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Add retry interceptor
    dio.interceptors.add(
      NetworkInterceptor(
        maxRetries: maxRetries,
        retryDelay: retryDelay,
        timeout: timeout,
      ),
    );

    // Add logging interceptor (optional)
    if (enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          logPrint: (obj) => debugPrint('📡 [Dio] $obj'),
        ),
      );
    }

    debugPrint('🔧 [NetworkClient] Created with:');
    debugPrint('   • Timeout: ${timeout.inSeconds}s');
    debugPrint('   • Max Retries: $maxRetries');
    debugPrint('   • Retry Delay: ${retryDelay.inSeconds}s');
    debugPrint('   • Logging: $enableLogging');

    return dio;
  }
}
