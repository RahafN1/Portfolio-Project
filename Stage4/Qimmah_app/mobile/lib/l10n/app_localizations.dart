import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'قمّة'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In ar, this message translates to:
  /// **'خلك دائماً بالقمّة'**
  String get tagline;

  /// No description provided for @startExploring.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الاستكشاف'**
  String get startExploring;

  /// No description provided for @haveAccount.
  ///
  /// In ar, this message translates to:
  /// **'عندك حساب؟'**
  String get haveAccount;

  /// No description provided for @loginLink.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك'**
  String get loginLink;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن مسار...'**
  String get searchHint;

  /// No description provided for @allRegions.
  ///
  /// In ar, this message translates to:
  /// **'كل المناطق'**
  String get allRegions;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @difficultyEasy.
  ///
  /// In ar, this message translates to:
  /// **'سهل'**
  String get difficultyEasy;

  /// No description provided for @difficultyModerate.
  ///
  /// In ar, this message translates to:
  /// **'متوسط'**
  String get difficultyModerate;

  /// No description provided for @difficultyHard.
  ///
  /// In ar, this message translates to:
  /// **'صعب'**
  String get difficultyHard;

  /// No description provided for @loadTrailsError.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نجيب المسارات'**
  String get loadTrailsError;

  /// No description provided for @welcomeUser.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً، {name}'**
  String welcomeUser(String name);

  /// No description provided for @reviewsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا توجد تقييمات} =1{تقييم واحد} =2{تقييمان} few{{count} تقييمات} many{{count} تقييماً} other{{count} تقييم}}'**
  String reviewsCount(int count);

  /// No description provided for @tabExplore.
  ///
  /// In ar, this message translates to:
  /// **'استكشف'**
  String get tabExplore;

  /// No description provided for @tabMap.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get tabMap;

  /// No description provided for @tabMyTrails.
  ///
  /// In ar, this message translates to:
  /// **'مساراتي'**
  String get tabMyTrails;

  /// No description provided for @tabProfile.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get tabProfile;

  /// No description provided for @profileTitle.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get profileTitle;

  /// No description provided for @accountSection.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get accountSection;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل البيانات'**
  String get editProfile;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @statSaved.
  ///
  /// In ar, this message translates to:
  /// **'محفوظة'**
  String get statSaved;

  /// No description provided for @statCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get statCompleted;

  /// No description provided for @statKmWalked.
  ///
  /// In ar, this message translates to:
  /// **'كم مشي'**
  String get statKmWalked;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @filterTrails.
  ///
  /// In ar, this message translates to:
  /// **'تصفية المسارات'**
  String get filterTrails;

  /// No description provided for @resetShort.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط'**
  String get resetShort;

  /// No description provided for @difficulty.
  ///
  /// In ar, this message translates to:
  /// **'الصعوبة'**
  String get difficulty;

  /// No description provided for @region.
  ///
  /// In ar, this message translates to:
  /// **'المنطقة'**
  String get region;

  /// No description provided for @showTrails.
  ///
  /// In ar, this message translates to:
  /// **'عرض {count} مسار'**
  String showTrails(int count);

  /// No description provided for @firstName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الأول'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العائلة'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @emailCannotChange.
  ///
  /// In ar, this message translates to:
  /// **'البريد ما يتغير'**
  String get emailCannotChange;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get saveChanges;

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get account;

  /// No description provided for @changesSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ التعديلات'**
  String get changesSaved;

  /// No description provided for @saveFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الحفظ'**
  String get saveFailed;

  /// No description provided for @guestTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنت تتصفح كزائر'**
  String get guestTitle;

  /// No description provided for @guestMessage.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك عشان تحفظ مساراتك وتقيّمها وتتابع إنجازاتك.'**
  String get guestMessage;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @trailsSection.
  ///
  /// In ar, this message translates to:
  /// **'المسارات'**
  String get trailsSection;

  /// No description provided for @noTrailsMatch.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه مسارات تطابق بحثك'**
  String get noTrailsMatch;

  /// No description provided for @resetFilters.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط الفلاتر'**
  String get resetFilters;

  /// No description provided for @loadMoreFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحمّل المزيد'**
  String get loadMoreFailed;

  /// No description provided for @appSlogan.
  ///
  /// In ar, this message translates to:
  /// **'مسارك...للقمة'**
  String get appSlogan;

  /// No description provided for @adminBrandLatin.
  ///
  /// In ar, this message translates to:
  /// **'Qimmah'**
  String get adminBrandLatin;

  /// No description provided for @adminBrandArabic.
  ///
  /// In ar, this message translates to:
  /// **'قمّة'**
  String get adminBrandArabic;

  /// No description provided for @adminEditTrailTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل مسار'**
  String get adminEditTrailTitle;

  /// No description provided for @adminAddTrailTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مسار'**
  String get adminAddTrailTitle;

  /// No description provided for @adminTrailImages.
  ///
  /// In ar, this message translates to:
  /// **'صور المسار'**
  String get adminTrailImages;

  /// No description provided for @adminTrailNameAr.
  ///
  /// In ar, this message translates to:
  /// **'اسم المسار بالعربي'**
  String get adminTrailNameAr;

  /// No description provided for @adminTrailNameArHint.
  ///
  /// In ar, this message translates to:
  /// **'مسار وادي لجب'**
  String get adminTrailNameArHint;

  /// No description provided for @adminTrailNameEn.
  ///
  /// In ar, this message translates to:
  /// **'اسم المسار بالإنجليزي'**
  String get adminTrailNameEn;

  /// No description provided for @adminSelectRegionHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر المنطقة'**
  String get adminSelectRegionHint;

  /// No description provided for @adminDistanceKm.
  ///
  /// In ar, this message translates to:
  /// **'المسافة (كم)'**
  String get adminDistanceKm;

  /// No description provided for @adminDurationHours.
  ///
  /// In ar, this message translates to:
  /// **'المدة المتوقعة (ساعات)'**
  String get adminDurationHours;

  /// No description provided for @adminTrailAbout.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عن المسار'**
  String get adminTrailAbout;

  /// No description provided for @adminTrailAboutHint.
  ///
  /// In ar, this message translates to:
  /// **'وصف مختصر للمسار وطبيعته...'**
  String get adminTrailAboutHint;

  /// No description provided for @adminPublishTrail.
  ///
  /// In ar, this message translates to:
  /// **'نشر المسار'**
  String get adminPublishTrail;

  /// No description provided for @adminCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get adminCancel;

  /// No description provided for @adminAddImage.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صورة'**
  String get adminAddImage;

  /// No description provided for @adminEnterNameAr.
  ///
  /// In ar, this message translates to:
  /// **'اكتبي اسم المسار بالعربي'**
  String get adminEnterNameAr;

  /// No description provided for @adminChooseRegion.
  ///
  /// In ar, this message translates to:
  /// **'اختاري المنطقة'**
  String get adminChooseRegion;

  /// No description provided for @adminEnterDistance.
  ///
  /// In ar, this message translates to:
  /// **'اكتبي المسافة كرقم صحيح'**
  String get adminEnterDistance;

  /// No description provided for @adminEnterDuration.
  ///
  /// In ar, this message translates to:
  /// **'اكتبي المدة المتوقعة'**
  String get adminEnterDuration;

  /// No description provided for @adminEnterAbout.
  ///
  /// In ar, this message translates to:
  /// **'اكتبي نبذة عن المسار'**
  String get adminEnterAbout;

  /// No description provided for @adminTrailPublished.
  ///
  /// In ar, this message translates to:
  /// **'تم نشر المسار'**
  String get adminTrailPublished;

  /// No description provided for @adminSaveTrailFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحفظ المسار، حاول مرة ثانية'**
  String get adminSaveTrailFailed;

  /// No description provided for @adminRegionRiyadh.
  ///
  /// In ar, this message translates to:
  /// **'الرياض'**
  String get adminRegionRiyadh;

  /// No description provided for @adminRegionMakkah.
  ///
  /// In ar, this message translates to:
  /// **'مكة المكرمة'**
  String get adminRegionMakkah;

  /// No description provided for @adminRegionMadinah.
  ///
  /// In ar, this message translates to:
  /// **'المدينة المنورة'**
  String get adminRegionMadinah;

  /// No description provided for @adminRegionQassim.
  ///
  /// In ar, this message translates to:
  /// **'القصيم'**
  String get adminRegionQassim;

  /// No description provided for @adminRegionEastern.
  ///
  /// In ar, this message translates to:
  /// **'الشرقية'**
  String get adminRegionEastern;

  /// No description provided for @adminRegionAsir.
  ///
  /// In ar, this message translates to:
  /// **'عسير'**
  String get adminRegionAsir;

  /// No description provided for @adminRegionTabuk.
  ///
  /// In ar, this message translates to:
  /// **'تبوك'**
  String get adminRegionTabuk;

  /// No description provided for @adminRegionHail.
  ///
  /// In ar, this message translates to:
  /// **'حائل'**
  String get adminRegionHail;

  /// No description provided for @adminRegionNorthernBorders.
  ///
  /// In ar, this message translates to:
  /// **'الحدود الشمالية'**
  String get adminRegionNorthernBorders;

  /// No description provided for @adminRegionJazan.
  ///
  /// In ar, this message translates to:
  /// **'جازان'**
  String get adminRegionJazan;

  /// No description provided for @adminRegionNajran.
  ///
  /// In ar, this message translates to:
  /// **'نجران'**
  String get adminRegionNajran;

  /// No description provided for @adminRegionBaha.
  ///
  /// In ar, this message translates to:
  /// **'الباحة'**
  String get adminRegionBaha;

  /// No description provided for @adminRegionJawf.
  ///
  /// In ar, this message translates to:
  /// **'الجوف'**
  String get adminRegionJawf;

  /// No description provided for @adminLogoutConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج؟'**
  String get adminLogoutConfirmTitle;

  /// No description provided for @adminLogoutConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'بترجعين لصفحة البداية.'**
  String get adminLogoutConfirmMessage;

  /// No description provided for @adminLogoutConfirmButton.
  ///
  /// In ar, this message translates to:
  /// **'خروج'**
  String get adminLogoutConfirmButton;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get adminDashboardTitle;

  /// No description provided for @adminRetry.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة ثانية'**
  String get adminRetry;

  /// No description provided for @adminStatTrails.
  ///
  /// In ar, this message translates to:
  /// **'مسارات'**
  String get adminStatTrails;

  /// No description provided for @adminStatReviews.
  ///
  /// In ar, this message translates to:
  /// **'تقييمات'**
  String get adminStatReviews;

  /// No description provided for @adminStatUsers.
  ///
  /// In ar, this message translates to:
  /// **'مستخدمين'**
  String get adminStatUsers;

  /// No description provided for @adminTabReviews.
  ///
  /// In ar, this message translates to:
  /// **'التقييمات'**
  String get adminTabReviews;

  /// No description provided for @adminTabUsers.
  ///
  /// In ar, this message translates to:
  /// **'المستخدمين'**
  String get adminTabUsers;

  /// No description provided for @adminDeleteReviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف هذا التقييم؟'**
  String get adminDeleteReviewTitle;

  /// No description provided for @adminDeleteReviewMessage.
  ///
  /// In ar, this message translates to:
  /// **'بينحذف التقييم لأنه مخالف لسياسة المحتوى، وما يقدر صاحبه يرجعه.'**
  String get adminDeleteReviewMessage;

  /// No description provided for @adminDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get adminDelete;

  /// No description provided for @adminReviewDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف التقييم'**
  String get adminReviewDeleted;

  /// No description provided for @adminDeleteReviewFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحذف التقييم، حاول مرة ثانية'**
  String get adminDeleteReviewFailed;

  /// No description provided for @adminNoReviews.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه تقييمات'**
  String get adminNoReviews;

  /// No description provided for @adminDeleteReviewButton.
  ///
  /// In ar, this message translates to:
  /// **'حذف التقييم'**
  String get adminDeleteReviewButton;

  /// No description provided for @adminSuspendUserTitle.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف المستخدم؟'**
  String get adminSuspendUserTitle;

  /// No description provided for @adminSuspendUserMessage.
  ///
  /// In ar, this message translates to:
  /// **'ما يقدر يسجل دخول أو يكتب تقييمات لين تلغي الإيقاف.'**
  String get adminSuspendUserMessage;

  /// No description provided for @adminSuspend.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف'**
  String get adminSuspend;

  /// No description provided for @adminUnsuspend.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الإيقاف'**
  String get adminUnsuspend;

  /// No description provided for @adminGenericError.
  ///
  /// In ar, this message translates to:
  /// **'صار خطأ، حاول مرة ثانية'**
  String get adminGenericError;

  /// No description provided for @adminUserSuspended.
  ///
  /// In ar, this message translates to:
  /// **'تم إيقاف {name}'**
  String adminUserSuspended(String name);

  /// No description provided for @adminUserUnsuspended.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء إيقاف {name}'**
  String adminUserUnsuspended(String name);

  /// No description provided for @adminNoUsers.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه مستخدمين'**
  String get adminNoUsers;

  /// No description provided for @adminUserReviewsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} تقييمات'**
  String adminUserReviewsCount(int count);

  /// No description provided for @adminStatusSuspended.
  ///
  /// In ar, this message translates to:
  /// **'موقوف'**
  String get adminStatusSuspended;

  /// No description provided for @adminStatusActive.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get adminStatusActive;

  /// No description provided for @adminDeleteTrailTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف المسار؟'**
  String get adminDeleteTrailTitle;

  /// No description provided for @adminDeleteTrailMessage.
  ///
  /// In ar, this message translates to:
  /// **'بينحذف \"{name}\" مع كل تقييماته ومفضلاته نهائياً.'**
  String adminDeleteTrailMessage(String name);

  /// No description provided for @adminTrailDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المسار'**
  String get adminTrailDeleted;

  /// No description provided for @adminDeleteTrailFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحذف المسار، حاول مرة ثانية'**
  String get adminDeleteTrailFailed;

  /// No description provided for @adminNoTrails.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه مسارات'**
  String get adminNoTrails;

  /// No description provided for @adminEditTrailTooltip.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المسار'**
  String get adminEditTrailTooltip;

  /// No description provided for @adminDeleteTrailTooltip.
  ///
  /// In ar, this message translates to:
  /// **'حذف المسار'**
  String get adminDeleteTrailTooltip;

  /// No description provided for @adminLoadError.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحمّل بيانات لوحة التحكم'**
  String get adminLoadError;

  /// No description provided for @adminTimeAgoMonths.
  ///
  /// In ar, this message translates to:
  /// **'قبل {count} شهر'**
  String adminTimeAgoMonths(int count);

  /// No description provided for @adminTimeAgoDays.
  ///
  /// In ar, this message translates to:
  /// **'قبل {count} يوم'**
  String adminTimeAgoDays(int count);

  /// No description provided for @adminTimeAgoHours.
  ///
  /// In ar, this message translates to:
  /// **'قبل {count} ساعة'**
  String adminTimeAgoHours(int count);

  /// No description provided for @adminTimeAgoMinutes.
  ///
  /// In ar, this message translates to:
  /// **'قبل دقائق'**
  String get adminTimeAgoMinutes;

  /// No description provided for @reviewsDeleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف تقييمك؟'**
  String get reviewsDeleteTitle;

  /// No description provided for @reviewsDeleteMessage.
  ///
  /// In ar, this message translates to:
  /// **'بينحذف تقييمك وتعليقك على هذا المسار نهائياً.'**
  String get reviewsDeleteMessage;

  /// No description provided for @reviewsCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get reviewsCancel;

  /// No description provided for @reviewsDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get reviewsDelete;

  /// No description provided for @reviewsWriteTitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتب تقييمك'**
  String get reviewsWriteTitle;

  /// No description provided for @reviewsYourRating.
  ///
  /// In ar, this message translates to:
  /// **'تقييمك للمسار'**
  String get reviewsYourRating;

  /// No description provided for @reviewsYourComment.
  ///
  /// In ar, this message translates to:
  /// **'تعليقك'**
  String get reviewsYourComment;

  /// No description provided for @reviewsCommentHint.
  ///
  /// In ar, this message translates to:
  /// **'شاركنا تجربتك في المسار...'**
  String get reviewsCommentHint;

  /// No description provided for @reviewsPublish.
  ///
  /// In ar, this message translates to:
  /// **'نشر التقييم'**
  String get reviewsPublish;

  /// No description provided for @reviewsAnonymousUser.
  ///
  /// In ar, this message translates to:
  /// **'مستخدم'**
  String get reviewsAnonymousUser;

  /// No description provided for @reviewsNameYou.
  ///
  /// In ar, this message translates to:
  /// **'{name} (أنت)'**
  String reviewsNameYou(String name);

  /// No description provided for @reviewsDeleteYours.
  ///
  /// In ar, this message translates to:
  /// **'حذف تقييمك'**
  String get reviewsDeleteYours;

  /// No description provided for @reviewsGuestLoginToRate.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك عشان تقيّم المسار'**
  String get reviewsGuestLoginToRate;

  /// No description provided for @reviewsPosted.
  ///
  /// In ar, this message translates to:
  /// **'تم نشر تقييمك، شكراً لك!'**
  String get reviewsPosted;

  /// No description provided for @reviewsDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف تقييمك'**
  String get reviewsDeleted;

  /// No description provided for @reviewsDeleteFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحذف التقييم، حاول مرة ثانية'**
  String get reviewsDeleteFailed;

  /// No description provided for @reviewsTitle.
  ///
  /// In ar, this message translates to:
  /// **'التقييمات'**
  String get reviewsTitle;

  /// No description provided for @reviewsTitleWithCount.
  ///
  /// In ar, this message translates to:
  /// **'التقييمات ({count})'**
  String reviewsTitleWithCount(int count);

  /// No description provided for @reviewsRetry.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة ثانية'**
  String get reviewsRetry;

  /// No description provided for @reviewsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه تقييمات للحين، كن أول من يقيّم هذا المسار.'**
  String get reviewsEmpty;

  /// No description provided for @reviewsLoadError.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحمّل التقييمات'**
  String get reviewsLoadError;

  /// No description provided for @reviewsSessionExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت جلستك، سجّل دخولك مرة ثانية'**
  String get reviewsSessionExpired;

  /// No description provided for @reviewsPublishFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا ننشر التقييم، حاول مرة ثانية'**
  String get reviewsPublishFailed;

  /// No description provided for @coreRequestTimeout.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة الاتصال، حاول مرة ثانية'**
  String get coreRequestTimeout;

  /// No description provided for @coreGenericError.
  ///
  /// In ar, this message translates to:
  /// **'صار خطأ، حاول مرة ثانية'**
  String get coreGenericError;

  /// No description provided for @coreComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'{title} — قريباً'**
  String coreComingSoon(String title);

  /// No description provided for @coreGuestSheetTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك عشان تحفظ المسار'**
  String get coreGuestSheetTitle;

  /// No description provided for @coreGuestSheetBody.
  ///
  /// In ar, this message translates to:
  /// **'الحفظ والتقييم وتسجيل المسارات المكتملة متاحة للمستخدمين المسجلين.'**
  String get coreGuestSheetBody;

  /// No description provided for @coreNotNow.
  ///
  /// In ar, this message translates to:
  /// **'ليس الآن'**
  String get coreNotNow;

  /// No description provided for @authGuestName.
  ///
  /// In ar, this message translates to:
  /// **'ضيف'**
  String get authGuestName;

  /// No description provided for @authCheckConnection.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من اتصالك بالإنترنت'**
  String get authCheckConnection;

  /// No description provided for @authFillEmailPassword.
  ///
  /// In ar, this message translates to:
  /// **'عبّ الإيميل وكلمة المرور'**
  String get authFillEmailPassword;

  /// No description provided for @authLoginTitle.
  ///
  /// In ar, this message translates to:
  /// **'أهلًا من جديد'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك عشان تحفظ مساراتك وتقيّمها.'**
  String get authLoginSubtitle;

  /// No description provided for @authPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get authPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In ar, this message translates to:
  /// **'ما عندك حساب؟'**
  String get authNoAccount;

  /// No description provided for @authCreateAccount.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حساب جديد'**
  String get authCreateAccount;

  /// No description provided for @authOr.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get authOr;

  /// No description provided for @authBrowseAsGuest.
  ///
  /// In ar, this message translates to:
  /// **'تصفّح كزائر'**
  String get authBrowseAsGuest;

  /// No description provided for @authFillAllFields.
  ///
  /// In ar, this message translates to:
  /// **'عبّ كل الحقول'**
  String get authFillAllFields;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور 8 أحرف على الأقل'**
  String get authPasswordMinLength;

  /// No description provided for @authSignupTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك'**
  String get authSignupTitle;

  /// No description provided for @authSignupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حساب واحد تحفظ فيه مساراتك وإنجازاتك.'**
  String get authSignupSubtitle;

  /// No description provided for @authPasswordHint.
  ///
  /// In ar, this message translates to:
  /// **'8 أحرف على الأقل'**
  String get authPasswordHint;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get authCreateAccountButton;

  /// No description provided for @authNewCodeSent.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمز جديد'**
  String get authNewCodeSent;

  /// No description provided for @authOtpTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من بريدك'**
  String get authOtpTitle;

  /// No description provided for @authOtpSentTo.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمز من 6 أرقام إلى'**
  String get authOtpSentTo;

  /// No description provided for @authOtpLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get authOtpLabel;

  /// No description provided for @authOtpConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get authOtpConfirm;

  /// No description provided for @authOtpNotReceived.
  ///
  /// In ar, this message translates to:
  /// **'ما وصلك الرمز؟'**
  String get authOtpNotReceived;

  /// No description provided for @authOtpResendIn.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال بعد {seconds} ث'**
  String authOtpResendIn(int seconds);

  /// No description provided for @authOtpResend.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال'**
  String get authOtpResend;

  /// No description provided for @authChangeEmail.
  ///
  /// In ar, this message translates to:
  /// **'تغيير البريد الإلكتروني'**
  String get authChangeEmail;

  /// No description provided for @authAccountCreatedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء حسابك'**
  String get authAccountCreatedTitle;

  /// No description provided for @authAccountCreatedSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'كل شي جاهز، يلا نطلع للقمّة.'**
  String get authAccountCreatedSubtitle;

  /// No description provided for @authContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get authContinue;

  /// No description provided for @authBackToForm.
  ///
  /// In ar, this message translates to:
  /// **'رجوع للنموذج'**
  String get authBackToForm;

  /// No description provided for @splashLightMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الفاتح'**
  String get splashLightMode;

  /// No description provided for @splashDarkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الداكن'**
  String get splashDarkMode;

  /// No description provided for @mapTapHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على علامة لعرض المسار'**
  String get mapTapHint;

  /// No description provided for @mapDirections.
  ///
  /// In ar, this message translates to:
  /// **'الاتجاهات'**
  String get mapDirections;

  /// No description provided for @mapStartTrail.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ المسار'**
  String get mapStartTrail;

  /// No description provided for @mapViewDetails.
  ///
  /// In ar, this message translates to:
  /// **'عرض التفاصيل'**
  String get mapViewDetails;

  /// No description provided for @mapDirectionsError.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نفتح الخرائط'**
  String get mapDirectionsError;

  /// No description provided for @mapLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'نحتاج نعرف موقعك'**
  String get mapLocationTitle;

  /// No description provided for @mapLocationBody.
  ///
  /// In ar, this message translates to:
  /// **'عشان نوريك مكانك على الخريطة، ونتأكد إنك وأنت تمشي على المسار الصحيح. ما نشارك موقعك مع أحد.'**
  String get mapLocationBody;

  /// No description provided for @mapLocationAllow.
  ///
  /// In ar, this message translates to:
  /// **'السماح بالوصول للموقع'**
  String get mapLocationAllow;

  /// No description provided for @mapLocationNotNow.
  ///
  /// In ar, this message translates to:
  /// **'ليس الآن'**
  String get mapLocationNotNow;

  /// No description provided for @mapLocationError.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحدد موقعك. تأكد إن الموقع مفعّل ومسموح.'**
  String get mapLocationError;

  /// No description provided for @mapOnTrailTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنت على المسار'**
  String get mapOnTrailTitle;

  /// No description provided for @mapOnTrailEnd.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء'**
  String get mapOnTrailEnd;

  /// No description provided for @mapNoRoute.
  ///
  /// In ar, this message translates to:
  /// **'هذا المسار ما له خط على الخريطة بعد'**
  String get mapNoRoute;

  /// No description provided for @mapRecenter.
  ///
  /// In ar, this message translates to:
  /// **'تتبّعني'**
  String get mapRecenter;

  /// No description provided for @mapOnTrailOffRoute.
  ///
  /// In ar, this message translates to:
  /// **'ابتعدت عن المسار'**
  String get mapOnTrailOffRoute;

  /// No description provided for @mapOnTrailFinished.
  ///
  /// In ar, this message translates to:
  /// **'وصلت نهاية المسار 🎉'**
  String get mapOnTrailFinished;

  /// No description provided for @mapStartPointTitle.
  ///
  /// In ar, this message translates to:
  /// **'نقطة الانطلاق'**
  String get mapStartPointTitle;

  /// No description provided for @mapStartPointSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'افتح الموقع في تطبيق الخرائط'**
  String get mapStartPointSubtitle;

  /// No description provided for @mapDistanceAndDuration.
  ///
  /// In ar, this message translates to:
  /// **'{distance} كم · {duration}'**
  String mapDistanceAndDuration(String distance, String duration);

  /// No description provided for @mapDistanceMeters.
  ///
  /// In ar, this message translates to:
  /// **'{meters} م'**
  String mapDistanceMeters(int meters);

  /// No description provided for @mapDistanceKm.
  ///
  /// In ar, this message translates to:
  /// **'{km} كم'**
  String mapDistanceKm(String km);

  /// No description provided for @mapOnTrailRemaining.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي: {distance}'**
  String mapOnTrailRemaining(String distance);

  /// No description provided for @mapOnTrailUpdatedAgo.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث: قبل {seconds} ث'**
  String mapOnTrailUpdatedAgo(int seconds);

  /// No description provided for @profileInitialFallback.
  ///
  /// In ar, this message translates to:
  /// **'؟'**
  String get profileInitialFallback;

  /// No description provided for @profileLogoutMessage.
  ///
  /// In ar, this message translates to:
  /// **'سيرجع حسابك كزائر، ومساراتك تبقى محفوظة في حسابك.'**
  String get profileLogoutMessage;

  /// No description provided for @profileCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get profileCancel;

  /// No description provided for @profileLightMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الفاتح'**
  String get profileLightMode;

  /// No description provided for @profileDarkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الداكن'**
  String get profileDarkMode;

  /// No description provided for @favoritesUnsaveFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نلغي الحفظ، حاول مرة ثانية'**
  String get favoritesUnsaveFailed;

  /// No description provided for @favoritesRetry.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة ثانية'**
  String get favoritesRetry;

  /// No description provided for @favoritesNoSaved.
  ///
  /// In ar, this message translates to:
  /// **'ما حفظت أي مسار للحين'**
  String get favoritesNoSaved;

  /// No description provided for @favoritesNoCompleted.
  ///
  /// In ar, this message translates to:
  /// **'ما أكملت أي مسار للحين'**
  String get favoritesNoCompleted;

  /// No description provided for @favoritesUnsave.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الحفظ'**
  String get favoritesUnsave;

  /// No description provided for @favoritesDistanceKm.
  ///
  /// In ar, this message translates to:
  /// **'{distance} كم'**
  String favoritesDistanceKm(String distance);

  /// No description provided for @favoritesCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get favoritesCompleted;

  /// No description provided for @favoritesCompletedOn.
  ///
  /// In ar, this message translates to:
  /// **'أكملته {date}'**
  String favoritesCompletedOn(String date);

  /// No description provided for @favoritesGuestTitle.
  ///
  /// In ar, this message translates to:
  /// **'مساراتك في مكان واحد'**
  String get favoritesGuestTitle;

  /// No description provided for @favoritesGuestMessage.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك عشان تحفظ المسارات وتتابع إنجازاتك.'**
  String get favoritesGuestMessage;

  /// No description provided for @favoritesCompletedBanner.
  ///
  /// In ar, this message translates to:
  /// **'أكملت {count, plural, =1{مسارًا واحدًا} =2{مسارين} few{{count} مسارات} many{{count} مسارًا} other{{count} مسارًا}} · {distance} كم مشي'**
  String favoritesCompletedBanner(int count, String distance);

  /// No description provided for @favoritesTabSaved.
  ///
  /// In ar, this message translates to:
  /// **'المحفوظة ({count})'**
  String favoritesTabSaved(int count);

  /// No description provided for @favoritesTabCompleted.
  ///
  /// In ar, this message translates to:
  /// **'المكتملة ({count})'**
  String favoritesTabCompleted(int count);

  /// No description provided for @favoritesLoadError.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نجيب مساراتك'**
  String get favoritesLoadError;

  /// No description provided for @favoritesDate.
  ///
  /// In ar, this message translates to:
  /// **'{day} {month} {year}'**
  String favoritesDate(String day, String month, String year);

  /// No description provided for @favoritesMonthJan.
  ///
  /// In ar, this message translates to:
  /// **'يناير'**
  String get favoritesMonthJan;

  /// No description provided for @favoritesMonthFeb.
  ///
  /// In ar, this message translates to:
  /// **'فبراير'**
  String get favoritesMonthFeb;

  /// No description provided for @favoritesMonthMar.
  ///
  /// In ar, this message translates to:
  /// **'مارس'**
  String get favoritesMonthMar;

  /// No description provided for @favoritesMonthApr.
  ///
  /// In ar, this message translates to:
  /// **'أبريل'**
  String get favoritesMonthApr;

  /// No description provided for @favoritesMonthMay.
  ///
  /// In ar, this message translates to:
  /// **'مايو'**
  String get favoritesMonthMay;

  /// No description provided for @favoritesMonthJun.
  ///
  /// In ar, this message translates to:
  /// **'يونيو'**
  String get favoritesMonthJun;

  /// No description provided for @favoritesMonthJul.
  ///
  /// In ar, this message translates to:
  /// **'يوليو'**
  String get favoritesMonthJul;

  /// No description provided for @favoritesMonthAug.
  ///
  /// In ar, this message translates to:
  /// **'أغسطس'**
  String get favoritesMonthAug;

  /// No description provided for @favoritesMonthSep.
  ///
  /// In ar, this message translates to:
  /// **'سبتمبر'**
  String get favoritesMonthSep;

  /// No description provided for @favoritesMonthOct.
  ///
  /// In ar, this message translates to:
  /// **'أكتوبر'**
  String get favoritesMonthOct;

  /// No description provided for @favoritesMonthNov.
  ///
  /// In ar, this message translates to:
  /// **'نوفمبر'**
  String get favoritesMonthNov;

  /// No description provided for @favoritesMonthDec.
  ///
  /// In ar, this message translates to:
  /// **'ديسمبر'**
  String get favoritesMonthDec;

  /// No description provided for @trailsSaveFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحفظ المسار، حاول مرة ثانية'**
  String get trailsSaveFailed;

  /// No description provided for @trailsExplorerName.
  ///
  /// In ar, this message translates to:
  /// **'مستكشف'**
  String get trailsExplorerName;

  /// No description provided for @trailsRetry.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة ثانية'**
  String get trailsRetry;

  /// No description provided for @trailsLoadMoreRetry.
  ///
  /// In ar, this message translates to:
  /// **'{error}، حاول مرة ثانية'**
  String trailsLoadMoreRetry(String error);

  /// No description provided for @trailsSavedToast.
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ'**
  String get trailsSavedToast;

  /// No description provided for @trailsUnsavedToast.
  ///
  /// In ar, this message translates to:
  /// **'تم ازالة الحفظ'**
  String get trailsUnsavedToast;

  /// No description provided for @trailsLoginToComplete.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك عشان تسجّل المسار'**
  String get trailsLoginToComplete;

  /// No description provided for @trailsCompletedToast.
  ///
  /// In ar, this message translates to:
  /// **'مبروك! اكتمل المسار'**
  String get trailsCompletedToast;

  /// No description provided for @trailsUncompletedToast.
  ///
  /// In ar, this message translates to:
  /// **'تم ازالة المسار'**
  String get trailsUncompletedToast;

  /// No description provided for @trailsKm.
  ///
  /// In ar, this message translates to:
  /// **'{distance} كم'**
  String trailsKm(String distance);

  /// No description provided for @trailsAboutTitle.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عن المسار'**
  String get trailsAboutTitle;

  /// No description provided for @trailsStartPointTitle.
  ///
  /// In ar, this message translates to:
  /// **'نقطة البداية'**
  String get trailsStartPointTitle;

  /// No description provided for @trailsSafetyTipsTitle.
  ///
  /// In ar, this message translates to:
  /// **'نصائح السلامة'**
  String get trailsSafetyTipsTitle;

  /// No description provided for @trailsNoDescription.
  ///
  /// In ar, this message translates to:
  /// **'ما فيه نبذة لهذا المسار للحين.'**
  String get trailsNoDescription;

  /// No description provided for @trailsDetailsLoadError.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحمّل تفاصيل المسار'**
  String get trailsDetailsLoadError;

  /// No description provided for @trailsCertified.
  ///
  /// In ar, this message translates to:
  /// **'معتمد'**
  String get trailsCertified;

  /// No description provided for @trailsCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get trailsCompleted;

  /// No description provided for @trailsMarkCompleted.
  ///
  /// In ar, this message translates to:
  /// **'أكملت المسار'**
  String get trailsMarkCompleted;

  /// No description provided for @trailsSavedLabel.
  ///
  /// In ar, this message translates to:
  /// **'محفوظ'**
  String get trailsSavedLabel;

  /// No description provided for @trailsSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get trailsSave;

  /// No description provided for @trailsDistance.
  ///
  /// In ar, this message translates to:
  /// **'المسافة'**
  String get trailsDistance;

  /// No description provided for @trailsEstimatedDuration.
  ///
  /// In ar, this message translates to:
  /// **'المدة المتوقعة'**
  String get trailsEstimatedDuration;

  /// No description provided for @trailsLogoAr.
  ///
  /// In ar, this message translates to:
  /// **'قمّة'**
  String get trailsLogoAr;

  /// No description provided for @authForgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get authForgotPassword;

  /// No description provided for @authForgotSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتب إيميلك ونرسل لك رمز تعيدين فيه كلمة المرور.'**
  String get authForgotSubtitle;

  /// No description provided for @authSendResetCode.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرمز'**
  String get authSendResetCode;

  /// No description provided for @authEnterEmail.
  ///
  /// In ar, this message translates to:
  /// **'اكتب إيميلك'**
  String get authEnterEmail;

  /// No description provided for @authResetTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين كلمة المرور'**
  String get authResetTitle;

  /// No description provided for @authNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get authNewPassword;

  /// No description provided for @authPasswordRules.
  ///
  /// In ar, this message translates to:
  /// **'8 أحرف على الأقل، مع حرف إنجليزي كبير وحرف صغير ورقم'**
  String get authPasswordRules;

  /// No description provided for @authResetButton.
  ///
  /// In ar, this message translates to:
  /// **'تعيين كلمة المرور'**
  String get authResetButton;

  /// No description provided for @authResetSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير كلمة المرور. سجّل دخولك بكلمة المرور الجديدة.'**
  String get authResetSuccess;

  /// No description provided for @trailsLogoEn.
  ///
  /// In ar, this message translates to:
  /// **'Qimmah'**
  String get trailsLogoEn;

  /// No description provided for @deleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف حسابك نهائياً؟'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In ar, this message translates to:
  /// **'بينحذف حسابك مع كل تقييماتك ومساراتك المحفوظة نهائياً، وما نقدر نرجعها.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountDone.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف حسابك'**
  String get deleteAccountDone;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحذف الحساب، حاول مرة ثانية'**
  String get deleteAccountFailed;

  /// No description provided for @reportReview.
  ///
  /// In ar, this message translates to:
  /// **'الإبلاغ عن التقييم'**
  String get reportReview;

  /// No description provided for @reportReviewSubject.
  ///
  /// In ar, this message translates to:
  /// **'بلاغ عن تقييم'**
  String get reportReviewSubject;

  /// No description provided for @reportReviewFailed.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نفتح تطبيق البريد'**
  String get reportReviewFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
