import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/reviews/views/widgets/star_rating.dart';

Widget wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  testWidgets('يعرض 5 نجوم', (tester) async {
    await tester.pumpWidget(wrap(const StarRating(rating: 3)));
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
  });

  testWidgets('الضغط على النجمة الثالثة يرجّع 3', (tester) async {
    int? selected;
    await tester.pumpWidget(
      wrap(StarRating(rating: 0, onChanged: (v) => selected = v)),
    );
    await tester.tap(find.byIcon(Icons.star_rounded).at(2));
    expect(selected, 3);
  });

  testWidgets('بدون onChanged تكون للعرض فقط', (tester) async {
    await tester.pumpWidget(wrap(const StarRating(rating: 4)));
    expect(
      find.descendant(
        of: find.byType(StarRating),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
  });
}