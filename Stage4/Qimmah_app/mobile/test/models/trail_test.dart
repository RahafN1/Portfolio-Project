import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/trails/models/trail.dart';

void main() {
  test('fromJson يحوّل المسافة من نص إلى رقم', () {
    final trail = Trail.fromJson({
      'id': 1,
      'name': 'مسار تجريبي',
      'region': 'الرياض',
      'difficulty': 'easy',
      'distance': '5.5',
      'is_certified': true,
      'average_rating': '4.5',
    });
    expect(trail.distance, 5.5);
    expect(trail.isCertified, true);
    expect(trail.averageRating, 4.5);
  });

  test('averageRating يكون null إذا ما فيه تقييمات', () {
    final trail = Trail.fromJson({'id': 2, 'distance': 3});
    expect(trail.averageRating, isNull);
    expect(trail.name, '');
  });

  test('coverImage ياخذ أول صورة إذا ما فيه cover_image', () {
    final trail = Trail.fromJson({
      'id': 3,
      'distance': 1,
      'images': ['a.jpg', 'b.jpg'],
    });
    expect(trail.coverImage, 'a.jpg');
  });
}