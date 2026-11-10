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

  @override
  String get tabExplore => 'استكشف';

  @override
  String get tabMap => 'الخريطة';

  @override
  String get tabMyTrails => 'مساراتي';

  @override
  String get tabProfile => 'حسابي';

  @override
  String get profileTitle => 'حسابي';

  @override
  String get accountSection => 'الحساب';

  @override
  String get editProfile => 'تعديل البيانات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get statSaved => 'محفوظة';

  @override
  String get statCompleted => 'مكتملة';

  @override
  String get statKmWalked => 'كم مشي';

  @override
  String get all => 'الكل';

  @override
  String get filterTrails => 'تصفية المسارات';

  @override
  String get resetShort => 'إعادة ضبط';

  @override
  String get difficulty => 'الصعوبة';

  @override
  String get region => 'المنطقة';

  @override
  String showTrails(int count) {
    return 'عرض $count مسار';
  }

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailCannotChange => 'البريد ما يتغير';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get account => 'الحساب';

  @override
  String get changesSaved => 'تم حفظ التعديلات';

  @override
  String get saveFailed => 'تعذر الحفظ';

  @override
  String get guestTitle => 'أنت تتصفح كزائر';

  @override
  String get guestMessage =>
      'سجّل دخولك عشان تحفظ مساراتك وتقيّمها وتتابع إنجازاتك.';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get trailsSection => 'المسارات';

  @override
  String get noTrailsMatch => 'ما فيه مسارات تطابق بحثك';

  @override
  String get resetFilters => 'إعادة ضبط الفلاتر';

  @override
  String get appSlogan => 'مسارك...للقمة';
}
