import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';

// يعرض أسباب التبليغ ويرجّع السبب المختار (أو null لو أغلق النافذة)
Future<String?> showReportReasonSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      final reasons = <String, String>{
        'spam': ctx.l10n.reportReasonSpam,
        'offensive': ctx.l10n.reportReasonOffensive,
        'inappropriate': ctx.l10n.reportReasonInappropriate,
        'other': ctx.l10n.reportReasonOther,
      };
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  ctx.l10n.reportReviewTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (final entry in reasons.entries)
                ListTile(
                  title: Text(entry.value),
                  onTap: () => Navigator.pop(ctx, entry.key),
                ),
            ],
          ),
        ),
      );
    },
  );
}