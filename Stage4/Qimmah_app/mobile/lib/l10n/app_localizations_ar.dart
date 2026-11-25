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
  String get loadMoreFailed => 'ما قدرنا نحمّل المزيد';

  @override
  String get appSlogan => 'مسارك...للقمة';

  @override
  String get adminBrandLatin => 'Qimmah';

  @override
  String get adminBrandArabic => 'قمّة';

  @override
  String get adminEditTrailTitle => 'تعديل مسار';

  @override
  String get adminAddTrailTitle => 'إضافة مسار';

  @override
  String get adminTrailImages => 'صور المسار';

  @override
  String get adminTrailNameAr => 'اسم المسار بالعربي';

  @override
  String get adminTrailNameArHint => 'مسار وادي لجب';

  @override
  String get adminTrailNameEn => 'اسم المسار بالإنجليزي';

  @override
  String get adminSelectRegionHint => 'اختر المنطقة';

  @override
  String get adminDistanceKm => 'المسافة (كم)';

  @override
  String get adminDurationHours => 'المدة المتوقعة (ساعات)';

  @override
  String get adminTrailAbout => 'نبذة عن المسار';

  @override
  String get adminTrailAboutHint => 'وصف مختصر للمسار وطبيعته...';

  @override
  String get adminPublishTrail => 'نشر المسار';

  @override
  String get adminCancel => 'إلغاء';

  @override
  String get adminAddImage => 'إضافة صورة';

  @override
  String get adminEnterNameAr => 'اكتبي اسم المسار بالعربي';

  @override
  String get adminChooseRegion => 'اختاري المنطقة';

  @override
  String get adminEnterDistance => 'اكتبي المسافة كرقم صحيح';

  @override
  String get adminEnterDuration => 'اكتبي المدة المتوقعة';

  @override
  String get adminEnterAbout => 'اكتبي نبذة عن المسار';

  @override
  String get adminTrailPublished => 'تم نشر المسار';

  @override
  String get adminSaveTrailFailed => 'ما قدرنا نحفظ المسار، حاول مرة ثانية';

  @override
  String get adminRegionRiyadh => 'الرياض';

  @override
  String get adminRegionMakkah => 'مكة المكرمة';

  @override
  String get adminRegionMadinah => 'المدينة المنورة';

  @override
  String get adminRegionQassim => 'القصيم';

  @override
  String get adminRegionEastern => 'الشرقية';

  @override
  String get adminRegionAsir => 'عسير';

  @override
  String get adminRegionTabuk => 'تبوك';

  @override
  String get adminRegionHail => 'حائل';

  @override
  String get adminRegionNorthernBorders => 'الحدود الشمالية';

  @override
  String get adminRegionJazan => 'جازان';

  @override
  String get adminRegionNajran => 'نجران';

  @override
  String get adminRegionBaha => 'الباحة';

  @override
  String get adminRegionJawf => 'الجوف';

  @override
  String get adminLogoutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get adminLogoutConfirmMessage => 'بترجعين لصفحة البداية.';

  @override
  String get adminLogoutConfirmButton => 'خروج';

  @override
  String get adminDashboardTitle => 'لوحة التحكم';

  @override
  String get adminRetry => 'حاول مرة ثانية';

  @override
  String get adminStatTrails => 'مسارات';

  @override
  String get adminStatReviews => 'تقييمات';

  @override
  String get adminStatUsers => 'مستخدمين';

  @override
  String get adminTabReviews => 'التقييمات';

  @override
  String get adminTabUsers => 'المستخدمين';

  @override
  String get adminDeleteReviewTitle => 'حذف هذا التقييم؟';

  @override
  String get adminDeleteReviewMessage =>
      'بينحذف التقييم لأنه مخالف لسياسة المحتوى، وما يقدر صاحبه يرجعه.';

  @override
  String get adminDelete => 'حذف';

  @override
  String get adminReviewDeleted => 'تم حذف التقييم';

  @override
  String get adminDeleteReviewFailed => 'ما قدرنا نحذف التقييم، حاول مرة ثانية';

  @override
  String get adminNoReviews => 'ما فيه تقييمات';

  @override
  String get adminDeleteReviewButton => 'حذف التقييم';

  @override
  String get adminSuspendUserTitle => 'إيقاف المستخدم؟';

  @override
  String get adminSuspendUserMessage =>
      'ما يقدر يسجل دخول أو يكتب تقييمات لين تلغي الإيقاف.';

  @override
  String get adminSuspend => 'إيقاف';

  @override
  String get adminUnsuspend => 'إلغاء الإيقاف';

  @override
  String get adminGenericError => 'صار خطأ، حاول مرة ثانية';

  @override
  String adminUserSuspended(String name) {
    return 'تم إيقاف $name';
  }

  @override
  String adminUserUnsuspended(String name) {
    return 'تم إلغاء إيقاف $name';
  }

  @override
  String get adminNoUsers => 'ما فيه مستخدمين';

  @override
  String adminUserReviewsCount(int count) {
    return '$count تقييمات';
  }

  @override
  String get adminStatusSuspended => 'موقوف';

  @override
  String get adminStatusActive => 'نشط';

  @override
  String get adminDeleteTrailTitle => 'حذف المسار؟';

  @override
  String adminDeleteTrailMessage(String name) {
    return 'بينحذف \"$name\" مع كل تقييماته ومفضلاته نهائياً.';
  }

  @override
  String get adminTrailDeleted => 'تم حذف المسار';

  @override
  String get adminDeleteTrailFailed => 'ما قدرنا نحذف المسار، حاول مرة ثانية';

  @override
  String get adminNoTrails => 'ما فيه مسارات';

  @override
  String get adminEditTrailTooltip => 'تعديل المسار';

  @override
  String get adminDeleteTrailTooltip => 'حذف المسار';

  @override
  String get adminLoadError => 'ما قدرنا نحمّل بيانات لوحة التحكم';

  @override
  String adminTimeAgoMonths(int count) {
    return 'قبل $count شهر';
  }

  @override
  String adminTimeAgoDays(int count) {
    return 'قبل $count يوم';
  }

  @override
  String adminTimeAgoHours(int count) {
    return 'قبل $count ساعة';
  }

  @override
  String get adminTimeAgoMinutes => 'قبل دقائق';

  @override
  String get reviewsDeleteTitle => 'حذف تقييمك؟';

  @override
  String get reviewsDeleteMessage =>
      'بينحذف تقييمك وتعليقك على هذا المسار نهائياً.';

  @override
  String get reviewsCancel => 'إلغاء';

  @override
  String get reviewsDelete => 'حذف';

  @override
  String get reviewsWriteTitle => 'اكتب تقييمك';

  @override
  String get reviewsYourRating => 'تقييمك للمسار';

  @override
  String get reviewsYourComment => 'تعليقك';

  @override
  String get reviewsCommentHint => 'شاركنا تجربتك في المسار...';

  @override
  String get reviewsPublish => 'نشر التقييم';

  @override
  String get reviewsAnonymousUser => 'مستخدم';

  @override
  String reviewsNameYou(String name) {
    return '$name (أنت)';
  }

  @override
  String get reviewsDeleteYours => 'حذف تقييمك';

  @override
  String get reviewsGuestLoginToRate => 'سجّل دخولك عشان تقيّم المسار';

  @override
  String get reviewsPosted => 'تم نشر تقييمك، شكراً لك!';

  @override
  String get reviewsDeleted => 'تم حذف تقييمك';

  @override
  String get reviewsDeleteFailed => 'ما قدرنا نحذف التقييم، حاول مرة ثانية';

  @override
  String get reviewsTitle => 'التقييمات';

  @override
  String reviewsTitleWithCount(int count) {
    return 'التقييمات ($count)';
  }

  @override
  String get reviewsRetry => 'حاول مرة ثانية';

  @override
  String get reviewsEmpty =>
      'ما فيه تقييمات للحين، كن أول من يقيّم هذا المسار.';

  @override
  String get reviewsLoadError => 'ما قدرنا نحمّل التقييمات';

  @override
  String get reviewsSessionExpired => 'انتهت جلستك، سجّل دخولك مرة ثانية';

  @override
  String get reviewsPublishFailed => 'ما قدرنا ننشر التقييم، حاول مرة ثانية';

  @override
  String get coreRequestTimeout => 'انتهت مهلة الاتصال، حاول مرة ثانية';

  @override
  String get coreGenericError => 'صار خطأ، حاول مرة ثانية';

  @override
  String coreComingSoon(String title) {
    return '$title — قريباً';
  }

  @override
  String get coreGuestSheetTitle => 'سجّل دخولك عشان تحفظ المسار';

  @override
  String get coreGuestSheetBody =>
      'الحفظ والتقييم وتسجيل المسارات المكتملة متاحة للمستخدمين المسجلين.';

  @override
  String get coreNotNow => 'ليس الآن';

  @override
  String get authGuestName => 'ضيف';

  @override
  String get authCheckConnection => 'تأكد من اتصالك بالإنترنت';

  @override
  String get authFillEmailPassword => 'عبّ الإيميل وكلمة المرور';

  @override
  String get authLoginTitle => 'أهلًا من جديد';

  @override
  String get authLoginSubtitle => 'سجّل دخولك عشان تحفظ مساراتك وتقيّمها.';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authNoAccount => 'ما عندك حساب؟';

  @override
  String get authCreateAccount => 'أنشئ حساب جديد';

  @override
  String get authOr => 'أو';

  @override
  String get authBrowseAsGuest => 'تصفّح كزائر';

  @override
  String get authFillAllFields => 'عبّ كل الحقول';

  @override
  String get authPasswordMinLength => 'كلمة المرور 8 أحرف على الأقل';

  @override
  String get authSignupTitle => 'أنشئ حسابك';

  @override
  String get authSignupSubtitle => 'حساب واحد تحفظ فيه مساراتك وإنجازاتك.';

  @override
  String get authPasswordHint => '8 أحرف على الأقل';

  @override
  String get authCreateAccountButton => 'إنشاء حساب';

  @override
  String get authNewCodeSent => 'أرسلنا رمز جديد';

  @override
  String get authOtpTitle => 'تحقق من بريدك';

  @override
  String get authOtpSentTo => 'أرسلنا رمز من 6 أرقام إلى';

  @override
  String get authOtpLabel => 'رمز التحقق';

  @override
  String get authOtpConfirm => 'تأكيد';

  @override
  String get authOtpNotReceived => 'ما وصلك الرمز؟';

  @override
  String authOtpResendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get authOtpResend => 'إعادة الإرسال';

  @override
  String get authChangeEmail => 'تغيير البريد الإلكتروني';

  @override
  String get authAccountCreatedTitle => 'تم إنشاء حسابك';

  @override
  String get authAccountCreatedSubtitle => 'كل شي جاهز، يلا نطلع للقمّة.';

  @override
  String get authContinue => 'متابعة';

  @override
  String get authBackToForm => 'رجوع للنموذج';

  @override
  String get splashLightMode => 'الوضع الفاتح';

  @override
  String get splashDarkMode => 'الوضع الداكن';

  @override
  String get mapTapHint => 'اضغط على علامة لعرض المسار';

  @override
  String get mapDirections => 'الاتجاهات';

  @override
  String get mapStartTrail => 'ابدأ المسار';

  @override
  String get mapViewDetails => 'عرض التفاصيل';

  @override
  String get mapDirectionsError => 'ما قدرنا نفتح الخرائط';

  @override
  String get mapLocationTitle => 'نحتاج نعرف موقعك';

  @override
  String get mapLocationBody =>
      'عشان نوريك مكانك على الخريطة، ونتأكد إنك وأنت تمشي على المسار الصحيح. ما نشارك موقعك مع أحد.';

  @override
  String get mapLocationAllow => 'السماح بالوصول للموقع';

  @override
  String get mapLocationNotNow => 'ليس الآن';

  @override
  String get mapLocationError =>
      'ما قدرنا نحدد موقعك. تأكد إن الموقع مفعّل ومسموح.';

  @override
  String get mapOnTrailTitle => 'أنت على المسار';

  @override
  String get mapOnTrailEnd => 'إنهاء';

  @override
  String get mapNoRoute => 'هذا المسار ما له خط على الخريطة بعد';

  @override
  String get mapRecenter => 'تتبّعني';

  @override
  String get mapOnTrailOffRoute => 'ابتعدت عن المسار';

  @override
  String get mapOnTrailFinished => 'وصلت نهاية المسار 🎉';

  @override
  String get mapStartPointTitle => 'نقطة الانطلاق';

  @override
  String get mapStartPointSubtitle => 'افتح الموقع في تطبيق الخرائط';

  @override
  String mapDistanceAndDuration(String distance, String duration) {
    return '$distance كم · $duration';
  }

  @override
  String mapDistanceMeters(int meters) {
    return '$meters م';
  }

  @override
  String mapDistanceKm(String km) {
    return '$km كم';
  }

  @override
  String mapOnTrailRemaining(String distance) {
    return 'المتبقي: $distance';
  }

  @override
  String mapOnTrailUpdatedAgo(int seconds) {
    return 'آخر تحديث: قبل $seconds ث';
  }

  @override
  String get profileInitialFallback => '؟';

  @override
  String get profileLogoutMessage =>
      'سيرجع حسابك كزائر، ومساراتك تبقى محفوظة في حسابك.';

  @override
  String get profileCancel => 'إلغاء';

  @override
  String get profileLightMode => 'الوضع الفاتح';

  @override
  String get profileDarkMode => 'الوضع الداكن';

  @override
  String get favoritesUnsaveFailed => 'ما قدرنا نلغي الحفظ، حاول مرة ثانية';

  @override
  String get favoritesRetry => 'حاول مرة ثانية';

  @override
  String get favoritesNoSaved => 'ما حفظت أي مسار للحين';

  @override
  String get favoritesNoCompleted => 'ما أكملت أي مسار للحين';

  @override
  String get favoritesUnsave => 'إلغاء الحفظ';

  @override
  String favoritesDistanceKm(String distance) {
    return '$distance كم';
  }

  @override
  String get favoritesCompleted => 'مكتمل';

  @override
  String favoritesCompletedOn(String date) {
    return 'أكملته $date';
  }

  @override
  String get favoritesGuestTitle => 'مساراتك في مكان واحد';

  @override
  String get favoritesGuestMessage =>
      'سجّل دخولك عشان تحفظ المسارات وتتابع إنجازاتك.';

  @override
  String favoritesCompletedBanner(int count, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مسارًا',
      many: '$count مسارًا',
      few: '$count مسارات',
      two: 'مسارين',
      one: 'مسارًا واحدًا',
    );
    return 'أكملت $_temp0 · $distance كم مشي';
  }

  @override
  String favoritesTabSaved(int count) {
    return 'المحفوظة ($count)';
  }

  @override
  String favoritesTabCompleted(int count) {
    return 'المكتملة ($count)';
  }

  @override
  String get favoritesLoadError => 'ما قدرنا نجيب مساراتك';

  @override
  String favoritesDate(String day, String month, String year) {
    return '$day $month $year';
  }

  @override
  String get favoritesMonthJan => 'يناير';

  @override
  String get favoritesMonthFeb => 'فبراير';

  @override
  String get favoritesMonthMar => 'مارس';

  @override
  String get favoritesMonthApr => 'أبريل';

  @override
  String get favoritesMonthMay => 'مايو';

  @override
  String get favoritesMonthJun => 'يونيو';

  @override
  String get favoritesMonthJul => 'يوليو';

  @override
  String get favoritesMonthAug => 'أغسطس';

  @override
  String get favoritesMonthSep => 'سبتمبر';

  @override
  String get favoritesMonthOct => 'أكتوبر';

  @override
  String get favoritesMonthNov => 'نوفمبر';

  @override
  String get favoritesMonthDec => 'ديسمبر';

  @override
  String get trailsSaveFailed => 'ما قدرنا نحفظ المسار، حاول مرة ثانية';

  @override
  String get trailsExplorerName => 'مستكشف';

  @override
  String get trailsRetry => 'حاول مرة ثانية';

  @override
  String trailsLoadMoreRetry(String error) {
    return '$error، حاول مرة ثانية';
  }

  @override
  String get trailsSavedToast => 'تم الحفظ';

  @override
  String get trailsUnsavedToast => 'تم ازالة الحفظ';

  @override
  String get trailsLoginToComplete => 'سجّل دخولك عشان تسجّل المسار';

  @override
  String get trailsCompletedToast => 'مبروك! اكتمل المسار';

  @override
  String get trailsUncompletedToast => 'تم ازالة المسار';

  @override
  String trailsKm(String distance) {
    return '$distance كم';
  }

  @override
  String get trailsAboutTitle => 'نبذة عن المسار';

  @override
  String get trailsStartPointTitle => 'نقطة البداية';

  @override
  String get trailsSafetyTipsTitle => 'نصائح السلامة';

  @override
  String get trailsNoDescription => 'ما فيه نبذة لهذا المسار للحين.';

  @override
  String get trailsDetailsLoadError => 'ما قدرنا نحمّل تفاصيل المسار';

  @override
  String get trailsCertified => 'معتمد';

  @override
  String get trailsCompleted => 'مكتمل';

  @override
  String get trailsMarkCompleted => 'أكملت المسار';

  @override
  String get trailsSavedLabel => 'محفوظ';

  @override
  String get trailsSave => 'حفظ';

  @override
  String get trailsDistance => 'المسافة';

  @override
  String get trailsEstimatedDuration => 'المدة المتوقعة';

  @override
  String get trailsLogoAr => 'قمّة';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authForgotSubtitle =>
      'اكتب إيميلك ونرسل لك رمز تعيدين فيه كلمة المرور.';

  @override
  String get authSendResetCode => 'إرسال الرمز';

  @override
  String get authEnterEmail => 'اكتب إيميلك';

  @override
  String get authResetTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get authNewPassword => 'كلمة المرور الجديدة';

  @override
  String get authPasswordRules =>
      '8 أحرف على الأقل، مع حرف إنجليزي كبير وحرف صغير ورقم';

  @override
  String get authResetButton => 'تعيين كلمة المرور';

  @override
  String get authResetSuccess =>
      'تم تغيير كلمة المرور. سجّل دخولك بكلمة المرور الجديدة.';

  @override
  String get trailsLogoEn => 'Qimmah';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountTitle => 'حذف حسابك نهائياً؟';

  @override
  String get deleteAccountMessage =>
      'بينحذف حسابك مع كل تقييماتك ومساراتك المحفوظة نهائياً، وما نقدر نرجعها.';

  @override
  String get deleteAccountDone => 'تم حذف حسابك';

  @override
  String get deleteAccountFailed => 'ما قدرنا نحذف الحساب، حاول مرة ثانية';

  @override
  String get reportReview => 'الإبلاغ عن التقييم';

  @override
  String get reportReviewSubject => 'بلاغ عن تقييم';

  @override
  String get reportReviewFailed => 'ما قدرنا نفتح تطبيق البريد';
}
