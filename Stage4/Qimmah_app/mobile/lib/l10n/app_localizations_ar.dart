// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'قمّة';

  @override
  String get tagline => 'خلك دائماً بالقمّة';

  @override
  String get startExploring => 'ابدأ الاستكشاف';

  @override
  String get haveAccount => 'عندك حساب؟';

  @override
  String get loginLink => 'سجّل دخولك';

  @override
  String get searchHint => 'ابحث عن مسار...';

  @override
  String get allRegions => 'كل المناطق';

  @override
  String get language => 'اللغة';

  @override
  String get difficultyEasy => 'سهل';

  @override
  String get difficultyModerate => 'متوسط';

  @override
  String get difficultyHard => 'صعب';

  @override
  String get loadTrailsError => 'ما قدرنا نجيب المسارات';

  @override
  String welcomeUser(String name) {
    return 'أهلاً، $name';
  }

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تقييم',
      many: '$count تقييماً',
      few: '$count تقييمات',
      two: 'تقييمان',
      one: 'تقييم واحد',
      zero: 'لا توجد تقييمات',
    );
    return '$_temp0';
  }
}
