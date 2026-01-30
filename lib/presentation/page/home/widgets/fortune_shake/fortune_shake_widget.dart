import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

import '../../../../../core/services/fortune_shake_service.dart';
import '../../../../../data/model/fortune/fortune_shake_model.dart';
import 'fortune_jar_painter.dart';
import 'fortune_stick_painter.dart';

class FortuneShakeWidget extends StatefulWidget {
  const FortuneShakeWidget({super.key});

  @override
  State<FortuneShakeWidget> createState() => _FortuneShakeWidgetState();
}

class _FortuneShakeWidgetState extends State<FortuneShakeWidget>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _slideController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _slideAnimation;

  FortuneShakeModel? _drawnFortune;
  bool _isShaking = false;
  bool _isRevealed = false;

  // Audio players
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
    );

    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _revealFortune();
      }
    });

    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isRevealed = true;
        });
      }
    });

    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.setVolume(0.5);
      await _backgroundPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      
      // Set audio context to allow mixing with other sounds
      await _backgroundPlayer.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {
              AVAudioSessionOptions.mixWithOthers,
            },
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );
      
      await _backgroundPlayer.play(AssetSource('audio/fortune_background.mp3'));
      debugPrint('🎵 Background music started');
      
      // Monitor background player state
      _backgroundPlayer.onPlayerStateChanged.listen((state) {
        debugPrint('🎵 Background player state: $state');
      });
    } catch (e) {
      debugPrint('❌ Error playing background music: $e');
    }
  }

  Future<void> _playShakeSound() async {
    try {
      debugPrint('🔊 Playing shake sound...');
      
      // Stop any previous effect sound
      await _effectPlayer.stop();
      
      // Configure effect player to not steal audio focus
      await _effectPlayer.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {
              AVAudioSessionOptions.mixWithOthers,
            },
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
        ),
      );
      
      // Lower background music volume temporarily
      await _backgroundPlayer.setVolume(0.2);
      debugPrint('🎵 Background volume lowered to 0.2');
      
      await _effectPlayer.setVolume(0.7);
      await _effectPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _effectPlayer.play(AssetSource('audio/shake_sound.mp3'));
      debugPrint('🔊 Shake sound started');
      
      // Restore background music volume after effect completes
      _effectPlayer.onPlayerComplete.first.then((_) async {
        debugPrint('🔊 Shake sound completed');
        await _backgroundPlayer.setVolume(0.5);
        debugPrint('🎵 Background volume restored to 0.5');
      });
      
      // Fallback: restore volume after 2 seconds even if onPlayerComplete doesn't fire
      Future.delayed(const Duration(seconds: 2), () async {
        await _backgroundPlayer.setVolume(0.5);
        debugPrint('🎵 Background volume restored to 0.5 (timeout fallback)');
      });
    } catch (e) {
      debugPrint('❌ Error playing shake sound: $e');
      // Restore volume even on error
      _backgroundPlayer.setVolume(0.5);
    }
  }

  Future<void> _playRevealSound() async {
    try {
      debugPrint('✨ Playing reveal sound...');
      
      // Stop any previous effect sound
      await _effectPlayer.stop();
      
      // Configure effect player to not steal audio focus
      await _effectPlayer.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {
              AVAudioSessionOptions.mixWithOthers,
            },
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.game,
            audioFocus: AndroidAudioFocus.gainTransientMayDuck,
          ),
        ),
      );
      
      // Lower background music volume temporarily
      await _backgroundPlayer.setVolume(0.2);
      debugPrint('🎵 Background volume lowered to 0.2');
      
      await _effectPlayer.setVolume(0.8);
      await _effectPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _effectPlayer.play(AssetSource('audio/reveal_sound.mp3'));
      debugPrint('✨ Reveal sound started');
      
      // Restore background music volume after effect completes
      _effectPlayer.onPlayerComplete.first.then((_) async {
        debugPrint('✨ Reveal sound completed');
        await _backgroundPlayer.setVolume(0.5);
        debugPrint('🎵 Background volume restored to 0.5');
      });
      
      // Fallback: restore volume after 2 seconds even if onPlayerComplete doesn't fire
      Future.delayed(const Duration(seconds: 2), () async {
        await _backgroundPlayer.setVolume(0.5);
        debugPrint('🎵 Background volume restored to 0.5 (timeout fallback)');
      });
    } catch (e) {
      debugPrint('❌ Error playing reveal sound: $e');
      // Restore volume even on error
      _backgroundPlayer.setVolume(0.5);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _slideController.dispose();
    _backgroundPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  void _shakeJar() {
    if (_isShaking || _drawnFortune != null) return;

    setState(() {
      _isShaking = true;
    });

    _playShakeSound();
    _shakeController.forward(from: 0);
  }

  void _revealFortune() {
    final fortune = FortuneShakeService.drawRandomFortune();
    setState(() {
      _drawnFortune = fortune;
    });

    // Wait a bit for shake sound to finish before playing reveal sound
    Future.delayed(const Duration(milliseconds: 200), () {
      _playRevealSound();
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward(from: 0);
    });
  }

  void _reset() {
    setState(() {
      _drawnFortune = null;
      _isShaking = false;
      _isRevealed = false;
    });
    _shakeController.reset();
    _slideController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFE5E5),
            const Color(0xFFFFD1D1),
            const Color(0xFFFFB7B7),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  'gieo_que_dau_xuan'.tr(),
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: const Color(0xFFD32F2F),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Multiple Sticks Inside Jar (before reveal) - Behind the jar
                    if (_drawnFortune == null)
                      Positioned(
                        top: 10.h,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return AnimatedBuilder(
                              animation: _shakeAnimation,
                              builder: (context, child) {
                                final offset =
                                    math.sin(
                                      (_shakeAnimation.value + index * 0.2) *
                                          math.pi *
                                          6,
                                    ) *
                                    3;
                                return Transform.translate(
                                  offset: Offset(offset, 0),
                                  child: Transform.rotate(
                                    angle: (index - 2) * 0.1,
                                    child: Container(
                                      width: 12,
                                      height: 80.h,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: CustomPaint(
                                        painter: FortuneStickPainter(
                                          slideProgress: 0,
                                          isRevealed: false,
                                          context: context,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),

                    // Revealed Stick - Behind the jar
                    if (_drawnFortune != null)
                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) {
                          return Positioned(
                            top: 50.h - (_slideAnimation.value * 100.h),
                            child: Opacity(
                              opacity: _slideAnimation.value,
                              child: Container(
                                width: 18,
                                height: 150.h,
                                child: CustomPaint(
                                  painter: FortuneStickPainter(
                                    slideProgress: _slideAnimation.value,
                                    isRevealed: _isRevealed,
                                    context: context,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    // Fortune Jar - On top of sticks
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        final shakeValue =
                            math.sin(_shakeAnimation.value * math.pi * 8) * 0.1;
                        return Transform.rotate(
                          angle: shakeValue,
                          child: GestureDetector(
                            onTap: _shakeJar,
                            child: Container(
                              width: 200.w,
                              height: 300.h,
                              child: CustomPaint(
                                painter: FortuneJarPainter(
                                  animationValue: _shakeAnimation.value,
                                  context: context,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Fortune Result Card
            if (_isRevealed && _drawnFortune != null)
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFE5E5),
                          const Color(0xFFFFFFFF),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _drawnFortune!.title.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium!.copyWith(
                            color: const Color(0xFFD32F2F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          _drawnFortune!.message.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: Colors.black87),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            _drawnFortune!.advice.tr(),
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _reset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Text(
                            'gieo_lai'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Instructions
            if (!_isShaking && _drawnFortune == null)
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 40.sp,
                      color: const Color(0xFFD32F2F).withOpacity(0.6),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'cham_de_gieo_que'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
