import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/trails/models/trail.dart';

Trail withDistance(double d) =>
    Trail(id: 1, name: '', region: '', difficulty: '', distance: d);

void main() {
  test('distanceText يشيل .0 من الرقم الصحيح', () {
    expect(withDistance(9.0).distanceText, '9');
  });

  test('distanceText يخلي الكسور', () {
    expect(withDistance(5.5).distanceText, '5.5');
  });
}
