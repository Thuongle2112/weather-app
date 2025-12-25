import 'package:easy_localization/easy_localization.dart';

class DateFormatter {
  static String formatFullDate(DateTime date, String locale) {
    try {
      switch (locale) {
        case 'vi':
          return DateFormat("EEEE, 'ngày' dd 'tháng' MM", locale).format(date);
        case 'ja':
          return DateFormat('M月d日 (EEEE)', locale).format(date);
        case 'ko':
          return DateFormat('M월 d일 EEEE', locale).format(date);
        case 'zh':
          return DateFormat('M月d日 EEEE', locale).format(date);
        case 'th':
          return DateFormat('EEEE ที่ d MMMM', locale).format(date);
        case 'fr':
          return DateFormat('EEEE d MMMM', locale).format(date);
        case 'de':
          return DateFormat('EEEE, d. MMMM', locale).format(date);
        case 'es':
          return DateFormat('EEEE, d \'de\' MMMM', locale).format(date);
        case 'en':
        default:
          return DateFormat('EEEE, MMMM d', locale).format(date);
      }
    } catch (e) {
      return DateFormat('EEEE, MMMM d', 'en').format(date);
    }
  }

  static String formatShortDate(DateTime date, String locale) {
    try {
      switch (locale) {
        case 'vi':
          return DateFormat("dd/MM", locale).format(date);
        case 'ja':
          return DateFormat('M月d日', locale).format(date);
        case 'ko':
          return DateFormat('M월 d일', locale).format(date);
        case 'zh':
          return DateFormat('M月d日', locale).format(date);
        case 'th':
          return DateFormat('d MMM', locale).format(date);
        case 'fr':
          return DateFormat('d MMM', locale).format(date);
        case 'de':
          return DateFormat('d. MMM', locale).format(date);
        case 'es':
          return DateFormat('d MMM', locale).format(date);
        case 'en':
        default:
          return DateFormat('MMM d', locale).format(date);
      }
    } catch (e) {
      return DateFormat('MMM d', 'en').format(date);
    }
  }

  static String formatMediumDate(DateTime date, String locale) {
    try {
      switch (locale) {
        case 'vi':
          return DateFormat("EEE, dd/MM", locale).format(date);
        case 'ja':
          return DateFormat('M月d日 (EEE)', locale).format(date);
        case 'ko':
          return DateFormat('M월 d일 EEE', locale).format(date);
        case 'zh':
          return DateFormat('M月d日 EEE', locale).format(date);
        case 'th':
          return DateFormat('EEE, d MMM', locale).format(date);
        case 'fr':
          return DateFormat('EEE d MMM', locale).format(date);
        case 'de':
          return DateFormat('EEE, d. MMM', locale).format(date);
        case 'es':
          return DateFormat('EEE, d MMM', locale).format(date);
        case 'en':
        default:
          return DateFormat('EEE, MMM d', locale).format(date);
      }
    } catch (e) {
      return DateFormat('EEE, MMM d', 'en').format(date);
    }
  }

  static String formatDayMonth(DateTime date, String locale) {
    try {
      switch (locale) {
        case 'vi':
          return DateFormat("dd 'Th'M", locale).format(date);
        case 'ja':
          return DateFormat('M月d日', locale).format(date);
        case 'ko':
          return DateFormat('M월 d일', locale).format(date);
        case 'zh':
          return DateFormat('M月d日', locale).format(date);
        case 'th':
          return DateFormat('d MMM', locale).format(date);
        case 'fr':
          return DateFormat('d MMM', locale).format(date);
        case 'de':
          return DateFormat('d. MMM', locale).format(date);
        case 'es':
          return DateFormat('d MMM', locale).format(date);
        case 'en':
        default:
          return DateFormat('MMM d', locale).format(date);
      }
    } catch (e) {
      return DateFormat('MMM d', 'en').format(date);
    }
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date, String locale) {
    final dateStr = formatShortDate(date, locale);
    final timeStr = formatTime(date);
    return '$dateStr, $timeStr';
  }
}
