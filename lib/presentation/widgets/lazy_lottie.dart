import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/services/animation_cache_service.dart';

/// Widget for lazy loading Lottie animations with caching
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
  });

  @override
  State<LazyLottie> createState() => _LazyLottieState();
}

class _LazyLottieState extends State<LazyLottie> {
  final _animationCache = AnimationCacheService();
  LottieComposition? _composition;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    if (!mounted) return;

    try {
      final composition = await _animationCache.get(widget.assetPath);
      
      if (!mounted) return;
      
      setState(() {
        _composition = composition;
        _isLoading = false;
      });

      widget.onLoaded?.call(composition);
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      debugPrint('❌ Failed to load animation: ${widget.assetPath} - $e');
    }
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
