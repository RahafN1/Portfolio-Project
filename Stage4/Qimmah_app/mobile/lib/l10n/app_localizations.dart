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

  /// No description provided for @appSlogan.
  ///
  /// In ar, this message translates to:
  /// **'مسارك...للقمة'**
  String get appSlogan;
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
