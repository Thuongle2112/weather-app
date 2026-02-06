import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';

import '../../core/services/animation_cache_service.dart';

/// Widget for lazy loading Lottie animations with caching and performance monitoring
class LazyLottie extends StatefulWidget {
  final String assetPath;
  final BoxFit? fit;
  final bool repeat;
  final AnimationController? controller;
  final void Function(LottieComposition)? onLoaded;
  final double? width;
  final double? height;
  final bool? animate;
  final FrameRate? frameRate;
  final bool enablePerformanceMonitoring;

  const LazyLottie({
    super.key,
    required this.assetPath,
    this.fit,
    this.repeat = true,
    this.controller,
    this.onLoaded,
    this.width,
    this.height,
    this.animate,
    this.frameRate,
    this.enablePerformanceMonitoring = kDebugMode,
  });

  @override
  State<LazyLottie> createState() => _LazyLottieState();
}

class _LazyLottieState extends State<LazyLottie> {
  final _animationCache = AnimationCacheService();
  LottieComposition? _composition;
  bool _isLoading = true;
  String? _error;
  DateTime? _loadStartTime;

  @override
  void initState() {
    super.initState();
    if (widget.enablePerformanceMonitoring) {
      _loadStartTime = DateTime.now();
    }
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    if (!mounted) return;

    try {
      final composition = await _animationCache.get(widget.assetPath);
      
      if (!mounted) return;
      
      // Performance monitoring
      if (widget.enablePerformanceMonitoring && _loadStartTime != null) {
        final loadDuration = DateTime.now().difference(_loadStartTime!);
        final fileName = widget.assetPath.split('/').last;
        
        debugPrint('⚡ [LazyLottie] Loaded: $fileName');
        debugPrint('   • Duration: ${loadDuration.inMilliseconds}ms');
        debugPrint('   • Frames: ${composition.durationFrames.toInt()}');
        debugPrint('   • FPS: ${composition.frameRate.toInt()}');
        debugPrint('   • Duration: ${(composition.duration.inMilliseconds / 1000).toStringAsFixed(1)}s');
        
        // Warning for large animations
        if (composition.durationFrames > 300) {
          debugPrint('   ⚠️ Large animation detected (${composition.durationFrames.toInt()} frames)');
          debugPrint('   💡 Consider optimizing or using lower frame rate');
        }
        
        // Warning for slow loading
        if (loadDuration.inMilliseconds > 200) {
          debugPrint('   ⚠️ Slow loading time (${loadDuration.inMilliseconds}ms)');
          debugPrint('   💡 Consider preloading this animation');
        }
      }
      
      setState(() {
        _composition = composition;
        _isLoading = false;
      });

      widget.onLoaded?.call(composition);
    } catch (e, stackTrace) {
      if (!mounted) return;
      
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      final fileName = widget.assetPath.split('/').last;
      debugPrint('❌ [LazyLottie] Failed to load: $fileName');
      debugPrint('   • Error: $e');
      if (widget.enablePerformanceMonitoring) {
        debugPrint('   • Stack: ${stackTrace.toString().split('\n').take(3).join('\n')}');
      }
    }
  }
  
  @override
  void dispose() {
    // Clear performance monitoring data
    _loadStartTime = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_error != null || _composition == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.grey),
        ),
      );
    }

    return Lottie(
      composition: _composition,
      fit: widget.fit,
      repeat: widget.repeat,
      controller: widget.controller,
      width: widget.width,
      height: widget.height,
      animate: widget.animate,
      frameRate: widget.frameRate,
    );
  }
}
