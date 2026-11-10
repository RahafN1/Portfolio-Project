// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Qimmah';

  @override
  String get tagline => 'Always at the summit';

  @override
  String get startExploring => 'Start exploring';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get loginLink => 'Log in';

  @override
  String get searchHint => 'Search for a trail...';

  @override
  String get allRegions => 'All regions';

  @override
  String get language => 'Language';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyModerate => 'Moderate';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get loadTrailsError => 'Couldn\'t load trails';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
      zero: 'No reviews',
    );
    return '$_temp0';
  }
}
