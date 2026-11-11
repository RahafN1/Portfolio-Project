import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

String difficultyLabel(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  switch (key) {
    case 'easy':
      return l10n.difficultyEasy;
    case 'moderate':
      return l10n.difficultyModerate;
    case 'hard':
      return l10n.difficultyHard;
    default:
      return key;
  }
  
}
