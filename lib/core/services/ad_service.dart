import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:easy_localization/easy_localization.dart';

class AdService {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isAdLoaded = false;
  int _interstitialLoadAttempts = 0;
  int _rewardedLoadAttempts = 0;
  bool _isPremium = false;
  bool _isDisposed = false;
  
  // Idle preloading
  bool _isAppIdle = false;
  Timer? _idleTimer;
  AppLifecycleState? _lastLifecycleState;

  final int maxAdLoadAttempts = 3;
  final String bannerAdUnitId;
  final String interstitialAdUnitId;
  final String rewardedAdUnitId;

  AdService({
    required this.bannerAdUnitId,
    required this.interstitialAdUnitId,
    required this.rewardedAdUnitId,
  });

  bool get isAdLoaded => _isAdLoaded;
  bool get isPremium => _isPremium;
  BannerAd? get bannerAd => _bannerAd;
  InterstitialAd? get interstitialAd => _interstitialAd;
  RewardedAd? get rewardedAd => _rewardedAd;
  
  /// Called when app lifecycle changes
  void onAppLifecycleStateChanged(AppLifecycleState state) {
    _lastLifecycleState = state;
    
    if (state == AppLifecycleState.resumed) {
      // App is active, start idle detection
      _startIdleDetection();
    } else {
      // App is paused/inactive, cancel idle timer
      _cancelIdleDetection();
    }
  }
  
  /// Start idle detection - app is considered idle after 3 seconds of no user interaction
  void _startIdleDetection() {
    _cancelIdleDetection();
    
    _idleTimer = Timer(const Duration(seconds: 3), () {
      _isAppIdle = true;
      debugPrint('📱 App is idle - preloading ads...');
      _preloadAdsWhenIdle();
    });
  }
  
  /// Cancel idle detection
  void _cancelIdleDetection() {
    _idleTimer?.cancel();
    _idleTimer = null;
    _isAppIdle = false;
  }
  
  /// Reset idle state when user interacts with app
  void onUserInteraction() {
    if (_isAppIdle) {
      debugPrint('📱 User interaction detected - resetting idle state');
      _isAppIdle = false;
    }
    _startIdleDetection();
  }
  
  /// Preload ads when app is idle to improve performance
  void _preloadAdsWhenIdle() {
    if (_isPremium || _isDisposed) return;
    
    // Load interstitial ad if not already loaded
    if (_interstitialAd == null) {
      debugPrint('🎯 [Idle] Preloading interstitial ad...');
      loadInterstitialAd(isPreload: true);
    }
    
    // Load rewarded ad if not already loaded
    if (_rewardedAd == null) {
      debugPrint('🎯 [Idle] Preloading rewarded ad...');
      loadRewardedAd(isPreload: true);
    }
  }

  void loadBannerAd(VoidCallback onAdLoaded) {
    if (_isPremium) return;

    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded successfully');
          _isAdLoaded = true;
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );
    _bannerAd?.load();
  }

  void loadInterstitialAd({bool isPreload = false}) {
    if (_isPremium || _interstitialAd != null) return;

    final loadType = isPreload ? '[Preload]' : '[OnDemand]';
    debugPrint('🎬 $loadType Loading interstitial ad...');

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          debugPrint('✅ $loadType Interstitial ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ $loadType Interstitial ad failed to load: $error');
          _interstitialLoadAttempts++;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxAdLoadAttempts) {
            loadInterstitialAd(isPreload: isPreload);
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      debugPrint('Attempting to show interstitial before loaded');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Failed to show interstitial: $error');
        ad.dispose();
        loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void loadRewardedAd({bool isPreload = false}) {
    if (_rewardedAd != null) return;

    final loadType = isPreload ? '[Preload]' : '[OnDemand]';
    debugPrint('🎁 $loadType Loading rewarded ad...');

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoadAttempts = 0;
          debugPrint('✅ $loadType Rewarded ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ $loadType Rewarded ad failed to load: $error');
          _rewardedLoadAttempts++;
          _rewardedAd = null;
          if (_rewardedLoadAttempts <= maxAdLoadAttempts) {
            loadRewardedAd(isPreload: isPreload);
          }
        },
      ),
    );
  }

  void showRewardedAd(
    BuildContext context, {
    required VoidCallback onRewardEarned,
    required VoidCallback onAdDismissed,
  }) {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('reward_ad_not_ready'.tr())));
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onAdDismissed();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Failed to show rewarded ad: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        _isPremium = true;
        onRewardEarned();
      },
    );
    _rewardedAd = null;
  }

  void activatePremium(
    VoidCallback onPremiumActivated,
    VoidCallback onPremiumExpired,
  ) {
    _isPremium = true;
    _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;

    onPremiumActivated();

    Future.delayed(const Duration(hours: 1), () {
      _isPremium = false;
      onPremiumExpired();
    });
  }

  void dispose() {
    _isDisposed = true;
    _cancelIdleDetection();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd = null;
  }
}
