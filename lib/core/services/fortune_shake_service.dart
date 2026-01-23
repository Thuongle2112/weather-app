import 'dart:math';
import '../../data/model/fortune/fortune_shake_model.dart';

class FortuneShakeService {
  static final List<FortuneShakeModel> _fortunes = [
    FortuneShakeModel(
      id: '1',
      title: 'fortune.great_fortune.title',
      message: 'fortune.great_fortune.message',
      advice: 'fortune.great_fortune.advice',
    ),
    FortuneShakeModel(
      id: '2',
      title: 'fortune.excellent_fortune.title',
      message: 'fortune.excellent_fortune.message',
      advice: 'fortune.excellent_fortune.advice',
    ),
    FortuneShakeModel(
      id: '3',
      title: 'fortune.good_fortune.title',
      message: 'fortune.good_fortune.message',
      advice: 'fortune.good_fortune.advice',
    ),
    FortuneShakeModel(
      id: '4',
      title: 'fortune.small_fortune.title',
      message: 'fortune.small_fortune.message',
      advice: 'fortune.small_fortune.advice',
    ),
    FortuneShakeModel(
      id: '5',
      title: 'fortune.neutral.title',
      message: 'fortune.neutral.message',
      advice: 'fortune.neutral.advice',
    ),
    FortuneShakeModel(
      id: '6',
      title: 'fortune.small_misfortune.title',
      message: 'fortune.small_misfortune.message',
      advice: 'fortune.small_misfortune.advice',
    ),
    FortuneShakeModel(
      id: '7',
      title: 'fortune.supreme_fortune.title',
      message: 'fortune.supreme_fortune.message',
      advice: 'fortune.supreme_fortune.advice',
    ),
    FortuneShakeModel(
      id: '8',
      title: 'fortune.joyful_fortune.title',
      message: 'fortune.joyful_fortune.message',
      advice: 'fortune.joyful_fortune.advice',
    ),
  ];

  static FortuneShakeModel drawRandomFortune() {
    final random = Random();
    final index = random.nextInt(_fortunes.length);
    return _fortunes[index];
  }

  static List<FortuneShakeModel> getAllFortunes() {
    return List.unmodifiable(_fortunes);
  }
}