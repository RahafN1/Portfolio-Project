import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/trails/models/trail.dart';
import 'package:mobile/features/trails/views/widgets/trail_card.dart';
import 'package:mobile/l10n/l10n.dart';

Widget wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(alignment: Alignment.topCenter, child: child),
      ),
    );

Trail makeTrail({
  double? rating,
  bool certified = false,
  double distance = 9,
  String duration = '3 hours',
  String difficulty = 'easy',
}) =>
    Trail(
      id: 1,
      name: 'Test Trail',
      region: 'Riyadh',
      difficulty: difficulty,
      distance: distance,
      estimatedDuration: duration,
      averageRating: rating,
      isCertified: certified,
    );

void main() {
  // TrailCard يقرا النصوص من L10n.tr، فنضبط اللغة للإنجليزي
  setUp(() => L10n.locale = const Locale('en'));
  tearDown(() => L10n.locale = const Locale('ar'));

  testWidgets('يعرض الاسم والمنطقة والصعوبة', (tester) async {
    await tester.pumpWidget(wrap(TrailCard(trail: makeTrail(), width: 360)));
    expect(find.text('Test Trail'), findsOneWidget);
    expect(find.text('Riyadh'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
  });

  testWidgets('يعرض التقييم إذا موجود', (tester) async {
    await tester.pumpWidget(
        wrap(TrailCard(trail: makeTrail(rating: 4.5), width: 360)));
    expect(find.text('4.5'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('يخفي التقييم إذا ما فيه تقييمات', (tester) async {
    await tester.pumpWidget(wrap(TrailCard(trail: makeTrail(), width: 360)));
    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('شارة معتمد تظهر للمسار المعتمد', (tester) async {
    await tester.pumpWidget(
        wrap(TrailCard(trail: makeTrail(certified: true), width: 360)));
    expect(find.text('Certified'), findsOneWidget);
  });

  testWidgets('شارة معتمد ما تظهر لغير المعتمد', (tester) async {
    await tester.pumpWidget(wrap(TrailCard(trail: makeTrail(), width: 360)));
    expect(find.text('Certified'), findsNothing);
  });

  testWidgets('يعرض المسافة مع المدة', (tester) async {
    await tester.pumpWidget(wrap(TrailCard(trail: makeTrail(), width: 360)));
    expect(find.text('9 km · 3 hours'), findsOneWidget);
  });

  testWidgets('يعرض المسافة بس إذا ما فيه مدة', (tester) async {
    await tester.pumpWidget(
        wrap(TrailCard(trail: makeTrail(duration: ''), width: 360)));
    expect(find.text('9 km'), findsOneWidget);
  });

  testWidgets('أيقونة الحفظ تتغير حسب isSaved', (tester) async {
    await tester.pumpWidget(wrap(TrailCard(trail: makeTrail(), width: 360)));
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    await tester.pumpWidget(
        wrap(TrailCard(trail: makeTrail(), width: 360, isSaved: true)));
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
  });

  testWidgets('الضغط على الكرت يشغل onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(wrap(
        TrailCard(trail: makeTrail(), width: 360, onTap: () => taps++)));
    await tester.tap(find.text('Test Trail'));
    expect(taps, 1);
  });

  testWidgets('الضغط على الحفظ يشغل onSaveTap بس', (tester) async {
    var cardTaps = 0;
    var saveTaps = 0;
    await tester.pumpWidget(wrap(TrailCard(
      trail: makeTrail(),
      width: 360,
      onTap: () => cardTaps++,
      onSaveTap: () => saveTaps++,
    )));
    await tester.tap(find.byIcon(Icons.bookmark_border));
    expect(saveTaps, 1);
    expect(cardTaps, 0);
  });
}
