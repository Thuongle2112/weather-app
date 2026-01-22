import 'dart:math';
import '../../data/model/fortune/fortune_shake_model.dart';

class FortuneShakeService {
  static final List<FortuneShakeModel> _fortunes = [
    FortuneShakeModel(
      id: '1',
      title: 'Đại Cát',
      message: 'Vạn sự như ý, tài lộc tràn đầy',
      advice: 'Đây là thời điểm tốt để bắt đầu những kế hoạch mới',
    ),
    FortuneShakeModel(
      id: '2',
      title: 'Thượng Cát',
      message: 'Công danh thăng tiến, may mắn gặp quý nhân',
      advice: 'Hãy mạnh dạn theo đuổi mục tiêu của bạn',
    ),
    FortuneShakeModel(
      id: '3',
      title: 'Trung Cát',
      message: 'Bình an vô sự, mọi việc hanh thông',
      advice: 'Giữ vững tinh thần lạc quan, tích cực',
    ),
    FortuneShakeModel(
      id: '4',
      title: 'Tiểu Cát',
      message: 'Gặp may trong công việc, tình duyên thêm mặn nồng',
      advice: 'Hãy trân trọng những người xung quanh',
    ),
    FortuneShakeModel(
      id: '5',
      title: 'Bình',
      message: 'Bình yên trong lòng, an nhiên tự tại',
      advice: 'Cần kiên nhẫn và chờ đợi thời cơ phù hợp',
    ),
    FortuneShakeModel(
      id: '6',
      title: 'Tiểu Hung',
      message: 'Có chút trắc trở nhỏ, cần cẩn thận',
      advice: 'Hãy thận trọng trong lời nói và hành động',
    ),
    FortuneShakeModel(
      id: '7',
      title: 'Thượng Thượng Cát',
      message: 'Phúc lộc đầy nhà, vận may liên tiếp',
      advice: 'Đây là năm của bạn, hãy tận hưởng!',
    ),
    FortuneShakeModel(
      id: '8',
      title: 'Hỷ Cát',
      message: 'Niềm vui sắp đến, tin vui từ xa',
      advice: 'Mở lòng đón nhận những điều tốt đẹp',
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
