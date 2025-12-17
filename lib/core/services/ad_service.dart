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

  void loadInterstitialAd() {
    if (_isPremium || _interstitialAd != null) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
          debugPrint('Interstitial ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialLoadAttempts++;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxAdLoadAttempts) {
            loadInterstitialAd();
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

  void loadRewardedAd() {
    if (_rewardedAd != null) return;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedLoadAttempts = 0;
          debugPrint('Rewarded ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          _rewardedLoadAttempts++;
          _rewardedAd = null;
          if (_rewardedLoadAttempts <= maxAdLoadAttempts) {
            loadRewardedAd();
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
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
