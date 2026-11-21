import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/trails/views/widgets/difficulty_chips.dart';
import 'package:mobile/l10n/l10n.dart';

Widget wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('يعرض الشرائح الأربع', (tester) async {
    await tester.pumpWidget(
        wrap(DifficultyChips(selected: null, onSelected: (_) {})));
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Moderate'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
  });

  testWidgets('الضغط على صعب يرجّع hard', (tester) async {
    final calls = <String?>[];
    await tester.pumpWidget(
        wrap(DifficultyChips(selected: null, onSelected: calls.add)));
    await tester.tap(find.text('Hard'));
    expect(calls, ['hard']);
  });

  testWidgets('الضغط على الكل يرجّع null', (tester) async {
    final calls = <String?>[];
    await tester.pumpWidget(
        wrap(DifficultyChips(selected: 'easy', onSelected: calls.add)));
    await tester.tap(find.text('All'));
    expect(calls, [null]);
  });
}
