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

  @override
  String get tabExplore => 'Explore';

  @override
  String get tabMap => 'Map';

  @override
  String get tabMyTrails => 'My trails';

  @override
  String get tabProfile => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get accountSection => 'Account';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get logout => 'Log out';

  @override
  String get statSaved => 'Saved';

  @override
  String get statCompleted => 'Completed';

  @override
  String get statKmWalked => 'km walked';

  @override
  String get all => 'All';

  @override
  String get filterTrails => 'Filter trails';

  @override
  String get resetShort => 'Reset';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get region => 'Region';

  @override
  String showTrails(int count) {
    return 'Show $count trails';
  }

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get email => 'Email';

  @override
  String get emailCannotChange => 'Email can\'t be changed';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get account => 'Account';

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get saveFailed => 'Couldn\'t save';

  @override
  String get guestTitle => 'You\'re browsing as a guest';

  @override
  String get guestMessage =>
      'Log in to save your trails, rate them, and track your achievements.';

  @override
  String get login => 'Log in';

  @override
  String get trailsSection => 'Trails';

  @override
  String get noTrailsMatch => 'No trails match your search';

  @override
  String get resetFilters => 'Reset filters';

  @override
  String get appSlogan => 'Your trail... to the summit';
}
