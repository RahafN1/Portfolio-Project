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
  String get loadMoreFailed => 'Couldn\'t load more';

  @override
  String get appSlogan => 'Your trail... to the summit';

  @override
  String get adminBrandLatin => 'Qimmah';

  @override
  String get adminBrandArabic => 'قمّة';

  @override
  String get adminEditTrailTitle => 'Edit trail';

  @override
  String get adminAddTrailTitle => 'Add trail';

  @override
  String get adminTrailImages => 'Trail photos';

  @override
  String get adminTrailNameAr => 'Trail name (Arabic)';

  @override
  String get adminTrailNameArHint => 'مسار وادي لجب';

  @override
  String get adminTrailNameEn => 'Trail name (English)';

  @override
  String get adminSelectRegionHint => 'Select a region';

  @override
  String get adminDistanceKm => 'Distance (km)';

  @override
  String get adminDurationHours => 'Estimated duration (hours)';

  @override
  String get adminTrailAbout => 'About the trail';

  @override
  String get adminTrailAboutHint =>
      'A short description of the trail and its terrain...';

  @override
  String get adminPublishTrail => 'Publish trail';

  @override
  String get adminCancel => 'Cancel';

  @override
  String get adminAddImage => 'Add photo';

  @override
  String get adminEnterNameAr => 'Enter the trail name in Arabic';

  @override
  String get adminChooseRegion => 'Choose a region';

  @override
  String get adminEnterDistance => 'Enter the distance as a valid number';

  @override
  String get adminEnterDuration => 'Enter the estimated duration';

  @override
  String get adminEnterAbout => 'Write a short description of the trail';

  @override
  String get adminTrailPublished => 'Trail published';

  @override
  String get adminSaveTrailFailed =>
      'Couldn\'t save the trail, please try again';

  @override
  String get adminRegionRiyadh => 'Riyadh';

  @override
  String get adminRegionMakkah => 'Makkah';

  @override
  String get adminRegionMadinah => 'Madinah';

  @override
  String get adminRegionQassim => 'Al-Qassim';

  @override
  String get adminRegionEastern => 'Eastern Province';

  @override
  String get adminRegionAsir => 'Asir';

  @override
  String get adminRegionTabuk => 'Tabuk';

  @override
  String get adminRegionHail => 'Hail';

  @override
  String get adminRegionNorthernBorders => 'Northern Borders';

  @override
  String get adminRegionJazan => 'Jazan';

  @override
  String get adminRegionNajran => 'Najran';

  @override
  String get adminRegionBaha => 'Al-Baha';

  @override
  String get adminRegionJawf => 'Al-Jawf';

  @override
  String get adminLogoutConfirmTitle => 'Log out?';

  @override
  String get adminLogoutConfirmMessage => 'You\'ll go back to the start page.';

  @override
  String get adminLogoutConfirmButton => 'Log out';

  @override
  String get adminDashboardTitle => 'Dashboard';

  @override
  String get adminRetry => 'Try again';

  @override
  String get adminStatTrails => 'Trails';

  @override
  String get adminStatReviews => 'Reviews';

  @override
  String get adminStatUsers => 'Users';

  @override
  String get adminTabReviews => 'Reviews';

  @override
  String get adminTabUsers => 'Users';

  @override
  String get adminDeleteReviewTitle => 'Delete this review?';

  @override
  String get adminDeleteReviewMessage =>
      'The review will be deleted for violating the content policy, and its author won\'t be able to restore it.';

  @override
  String get adminDelete => 'Delete';

  @override
  String get adminReviewDeleted => 'Review deleted';

  @override
  String get adminDeleteReviewFailed =>
      'Couldn\'t delete the review, please try again';

  @override
  String get adminNoReviews => 'No reviews';

  @override
  String get adminDeleteReviewButton => 'Delete review';

  @override
  String get adminSuspendUserTitle => 'Suspend this user?';

  @override
  String get adminSuspendUserMessage =>
      'They won\'t be able to log in or write reviews until you lift the suspension.';

  @override
  String get adminSuspend => 'Suspend';

  @override
  String get adminUnsuspend => 'Unsuspend';

  @override
  String get adminGenericError => 'Something went wrong, please try again';

  @override
  String adminUserSuspended(String name) {
    return '$name has been suspended';
  }

  @override
  String adminUserUnsuspended(String name) {
    return '$name has been unsuspended';
  }

  @override
  String get adminNoUsers => 'No users';

  @override
  String adminUserReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get adminStatusSuspended => 'Suspended';

  @override
  String get adminStatusActive => 'Active';

  @override
  String get adminDeleteTrailTitle => 'Delete this trail?';

  @override
  String adminDeleteTrailMessage(String name) {
    return '\"$name\" will be permanently deleted along with all its reviews and favorites.';
  }

  @override
  String get adminTrailDeleted => 'Trail deleted';

  @override
  String get adminDeleteTrailFailed =>
      'Couldn\'t delete the trail, please try again';

  @override
  String get adminNoTrails => 'No trails';

  @override
  String get adminEditTrailTooltip => 'Edit trail';

  @override
  String get adminDeleteTrailTooltip => 'Delete trail';

  @override
  String get adminLoadError => 'Couldn\'t load the dashboard data';

  @override
  String adminTimeAgoMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String adminTimeAgoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String adminTimeAgoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get adminTimeAgoMinutes => 'A few minutes ago';

  @override
  String get reviewsDeleteTitle => 'Delete your review?';

  @override
  String get reviewsDeleteMessage =>
      'Your rating and comment on this trail will be permanently deleted.';

  @override
  String get reviewsCancel => 'Cancel';

  @override
  String get reviewsDelete => 'Delete';

  @override
  String get reviewsWriteTitle => 'Write your review';

  @override
  String get reviewsYourRating => 'Your rating for the trail';

  @override
  String get reviewsYourComment => 'Your comment';

  @override
  String get reviewsCommentHint => 'Share your experience on the trail...';

  @override
  String get reviewsPublish => 'Post review';

  @override
  String get reviewsAnonymousUser => 'User';

  @override
  String reviewsNameYou(String name) {
    return '$name (You)';
  }

  @override
  String get reviewsDeleteYours => 'Delete your review';

  @override
  String get reviewsGuestLoginToRate => 'Log in to rate this trail';

  @override
  String get reviewsPosted => 'Your review is posted, thank you!';

  @override
  String get reviewsDeleted => 'Your review was deleted';

  @override
  String get reviewsDeleteFailed =>
      'Couldn\'t delete the review, please try again';

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String reviewsTitleWithCount(int count) {
    return 'Reviews ($count)';
  }

  @override
  String get reviewsRetry => 'Try again';

  @override
  String get reviewsEmpty =>
      'No reviews yet. Be the first to review this trail.';

  @override
  String get reviewsLoadError => 'Couldn\'t load reviews';

  @override
  String get reviewsSessionExpired =>
      'Your session expired, please log in again';

  @override
  String get reviewsPublishFailed =>
      'Couldn\'t post your review, please try again';

  @override
  String get coreRequestTimeout => 'Connection timed out, please try again';

  @override
  String get coreGenericError => 'Something went wrong, please try again';

  @override
  String coreComingSoon(String title) {
    return '$title — coming soon';
  }

  @override
  String get coreGuestSheetTitle => 'Log in to save this trail';

  @override
  String get coreGuestSheetBody =>
      'Saving, rating and logging completed trails are available to registered users.';

  @override
  String get coreNotNow => 'Not now';

  @override
  String get authGuestName => 'Guest';

  @override
  String get authCheckConnection => 'Check your internet connection';

  @override
  String get authFillEmailPassword => 'Enter your email and password';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Log in to save your trails and rate them.';

  @override
  String get authPassword => 'Password';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authCreateAccount => 'Create a new account';

  @override
  String get authOr => 'or';

  @override
  String get authBrowseAsGuest => 'Browse as a guest';

  @override
  String get authFillAllFields => 'Fill in all fields';

  @override
  String get authPasswordMinLength => 'Password must be at least 8 characters';

  @override
  String get authSignupTitle => 'Create your account';

  @override
  String get authSignupSubtitle =>
      'One account to keep your trails and achievements.';

  @override
  String get authPasswordHint => 'At least 8 characters';

  @override
  String get authCreateAccountButton => 'Sign up';

  @override
  String get authNewCodeSent => 'We\'ve sent you a new code';

  @override
  String get authOtpTitle => 'Check your email';

  @override
  String get authOtpSentTo => 'We\'ve sent a 6-digit code to';

  @override
  String get authOtpLabel => 'Verification code';

  @override
  String get authOtpConfirm => 'Confirm';

  @override
  String get authOtpNotReceived => 'Didn\'t get the code?';

  @override
  String authOtpResendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authOtpResend => 'Resend';

  @override
  String get authChangeEmail => 'Change email';

  @override
  String get authAccountCreatedTitle => 'Your account is ready';

  @override
  String get authAccountCreatedSubtitle =>
      'Everything\'s set, let\'s head to the summit.';

  @override
  String get authContinue => 'Continue';

  @override
  String get authBackToForm => 'Back to the form';

  @override
  String get splashLightMode => 'Light mode';

  @override
  String get splashDarkMode => 'Dark mode';

  @override
  String get mapTapHint => 'Tap a marker to view the trail';

  @override
  String get mapDirections => 'Directions';

  @override
  String get mapStartTrail => 'Start trail';

  @override
  String get mapViewDetails => 'View details';

  @override
  String get mapDirectionsError => 'We couldn\'t open Maps';

  @override
  String get mapLocationTitle => 'We need your location';

  @override
  String get mapLocationBody =>
      'So we can show where you are on the map and make sure you\'re on the right trail. We never share your location with anyone.';

  @override
  String get mapLocationAllow => 'Allow location access';

  @override
  String get mapLocationNotNow => 'Not now';

  @override
  String get mapLocationError =>
      'We couldn\'t find your location. Make sure location is turned on and allowed.';

  @override
  String get mapOnTrailTitle => 'You\'re on the trail';

  @override
  String get mapOnTrailEnd => 'End';

  @override
  String get mapNoRoute => 'This trail doesn\'t have a route on the map yet';

  @override
  String get mapRecenter => 'Follow me';

  @override
  String get mapOnTrailOffRoute => 'You\'ve moved off the trail';

  @override
  String get mapOnTrailFinished => 'You\'ve reached the end of the trail 🎉';

  @override
  String get mapStartPointTitle => 'Starting point';

  @override
  String get mapStartPointSubtitle => 'Open the location in your maps app';

  @override
  String mapDistanceAndDuration(String distance, String duration) {
    return '$distance km · $duration';
  }

  @override
  String mapDistanceMeters(int meters) {
    return '$meters m';
  }

  @override
  String mapDistanceKm(String km) {
    return '$km km';
  }

  @override
  String mapOnTrailRemaining(String distance) {
    return 'Remaining: $distance';
  }

  @override
  String mapOnTrailUpdatedAgo(int seconds) {
    return 'Last updated: ${seconds}s ago';
  }

  @override
  String get profileInitialFallback => '?';

  @override
  String get profileLogoutMessage =>
      'Your account will go back to guest mode, and your trails stay saved in your account.';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileLightMode => 'Light mode';

  @override
  String get profileDarkMode => 'Dark mode';

  @override
  String get favoritesUnsaveFailed =>
      'Couldn\'t unsave the trail, please try again';

  @override
  String get favoritesRetry => 'Try again';

  @override
  String get favoritesNoSaved => 'You haven\'t saved any trails yet';

  @override
  String get favoritesNoCompleted => 'You haven\'t completed any trails yet';

  @override
  String get favoritesUnsave => 'Unsave';

  @override
  String favoritesDistanceKm(String distance) {
    return '$distance km';
  }

  @override
  String get favoritesCompleted => 'Completed';

  @override
  String favoritesCompletedOn(String date) {
    return 'Completed on $date';
  }

  @override
  String get favoritesGuestTitle => 'All your trails in one place';

  @override
  String get favoritesGuestMessage =>
      'Log in to save trails and track your achievements.';

  @override
  String favoritesCompletedBanner(int count, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trails',
      one: '1 trail',
    );
    return 'You completed $_temp0 · $distance km walked';
  }

  @override
  String favoritesTabSaved(int count) {
    return 'Saved ($count)';
  }

  @override
  String favoritesTabCompleted(int count) {
    return 'Completed ($count)';
  }

  @override
  String get favoritesLoadError => 'We couldn\'t load your trails';

  @override
  String favoritesDate(String day, String month, String year) {
    return '$month $day, $year';
  }

  @override
  String get favoritesMonthJan => 'January';

  @override
  String get favoritesMonthFeb => 'February';

  @override
  String get favoritesMonthMar => 'March';

  @override
  String get favoritesMonthApr => 'April';

  @override
  String get favoritesMonthMay => 'May';

  @override
  String get favoritesMonthJun => 'June';

  @override
  String get favoritesMonthJul => 'July';

  @override
  String get favoritesMonthAug => 'August';

  @override
  String get favoritesMonthSep => 'September';

  @override
  String get favoritesMonthOct => 'October';

  @override
  String get favoritesMonthNov => 'November';

  @override
  String get favoritesMonthDec => 'December';

  @override
  String get trailsSaveFailed => 'Couldn\'t save the trail, please try again';

  @override
  String get trailsExplorerName => 'Explorer';

  @override
  String get trailsRetry => 'Try again';

  @override
  String trailsLoadMoreRetry(String error) {
    return '$error, try again';
  }

  @override
  String get trailsSavedToast => 'Saved';

  @override
  String get trailsUnsavedToast => 'Removed from saved';

  @override
  String get trailsLoginToComplete => 'Log in to mark this trail as completed';

  @override
  String get trailsCompletedToast => 'Congrats! Trail completed';

  @override
  String get trailsUncompletedToast => 'Removed from completed';

  @override
  String trailsKm(String distance) {
    return '$distance km';
  }

  @override
  String get trailsAboutTitle => 'About the trail';

  @override
  String get trailsStartPointTitle => 'Starting point';

  @override
  String get trailsSafetyTipsTitle => 'Safety tips';

  @override
  String get trailsNoDescription => 'No description for this trail yet.';

  @override
  String get trailsDetailsLoadError => 'Couldn\'t load trail details';

  @override
  String get trailsCertified => 'Certified';

  @override
  String get trailsCompleted => 'Completed';

  @override
  String get trailsMarkCompleted => 'Mark as completed';

  @override
  String get trailsSavedLabel => 'Saved';

  @override
  String get trailsSave => 'Save';

  @override
  String get trailsDistance => 'Distance';

  @override
  String get trailsEstimatedDuration => 'Estimated time';

  @override
  String get trailsLogoAr => 'قمّة';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authForgotSubtitle =>
      'Enter your email and we\'ll send you a code to reset your password.';

  @override
  String get authSendResetCode => 'Send code';

  @override
  String get authEnterEmail => 'Enter your email';

  @override
  String get authResetTitle => 'Reset password';

  @override
  String get authNewPassword => 'New password';

  @override
  String get authPasswordRules =>
      'At least 8 characters, with an uppercase letter, a lowercase letter and a number';

  @override
  String get authResetButton => 'Reset password';

  @override
  String get authResetSuccess =>
      'Your password was changed. Log in with your new password.';

  @override
  String get trailsLogoEn => 'Qimmah';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete your account permanently?';

  @override
  String get deleteAccountMessage =>
      'Your account, reviews and saved trails will be permanently deleted. This can\'t be undone.';

  @override
  String get deleteAccountDone => 'Your account was deleted';

  @override
  String get deleteAccountFailed =>
      'Couldn\'t delete your account, please try again';

  @override
  String get reportReview => 'Report review';

  @override
  String get reportReviewSubject => 'Review report';

  @override
  String get reportReviewFailed => 'Couldn\'t open the mail app';
}
