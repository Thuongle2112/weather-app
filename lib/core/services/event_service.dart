class EventService {
  // Define all events here
  static final Map<String, EventPeriod> _events = {
    'lunar_new_year_2026': EventPeriod(
      startDate: DateTime(2026, 1, 22),
      endDate: DateTime(2026, 2, 22, 23, 59, 59),
      specialDates: {
        'eve': DateTime(2026, 1, 28),
        'new_year_day': DateTime(2026, 1, 29),
      },
    ),
    // Dễ dàng thêm event mới
    // 'mid_autumn_2026': EventPeriod(
    //   startDate: DateTime(2026, 9, 15),
    //   endDate: DateTime(2026, 9, 20, 23, 59, 59),
    // ),
    // 'christmas_2026': EventPeriod(
    //   startDate: DateTime(2026, 12, 20),
    //   endDate: DateTime(2026, 12, 27, 23, 59, 59),
    // ),
  };

  /// Kiểm tra xem có đang trong event nào không
  static bool isEventActive(String eventKey) {
    final event = _events[eventKey];
    if (event == null) return false;
    
    final now = DateTime.now();
    return now.isAfter(event.startDate) && now.isBefore(event.endDate) || 
           now.isAtSameMomentAs(event.startDate);
  }

  /// Lấy số ngày còn lại của event
  static int? getDaysRemainingInEvent(String eventKey) {
    if (!isEventActive(eventKey)) return null;
    
    final event = _events[eventKey];
    final now = DateTime.now();
    
    return event!.endDate.difference(now).inDays;
  }

  /// Kiểm tra có phải ngày đặc biệt trong event không
  static bool isSpecialDate(String eventKey, String specialDateKey) {
    final event = _events[eventKey];
    if (event == null || event.specialDates == null) return false;
    
    final specialDate = event.specialDates![specialDateKey];
    if (specialDate == null) return false;
    
    final now = DateTime.now();
    return now.year == specialDate.year && 
           now.month == specialDate.month && 
           now.day == specialDate.day;
  }

  /// Lấy event hiện tại đang active
  static String? getCurrentActiveEvent() {
    for (var entry in _events.entries) {
      if (isEventActive(entry.key)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Lấy tất cả events đang active
  static List<String> getAllActiveEvents() {
    return _events.entries
        .where((entry) => isEventActive(entry.key))
        .map((entry) => entry.key)
        .toList();
  }

  // Backwards compatibility - giữ nguyên API cũ
  static bool isLunarNewYearEvent() => isEventActive('lunar_new_year_2026');
  
  static int? getDaysRemainingInLunarNewYearEvent() => 
      getDaysRemainingInEvent('lunar_new_year_2026');
  
  static bool isLunarNewYearEve() => 
      isSpecialDate('lunar_new_year_2026', 'eve');
  
  static bool isLunarNewYearDay() => 
      isSpecialDate('lunar_new_year_2026', 'new_year_day');
}

/// Model cho event period
class EventPeriod {
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, DateTime>? specialDates;

  EventPeriod({
    required this.startDate,
    required this.endDate,
    this.specialDates,
  });
}