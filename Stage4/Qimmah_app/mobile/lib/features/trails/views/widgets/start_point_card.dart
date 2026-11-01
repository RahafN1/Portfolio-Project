import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

// كرت نقطة البداية: رسمة خريطة + زر "الاتجاهات"
// (الرسمة تزيينية، الاتجاهات الحقيقية تنفتح في تطبيق الخرائط)
class StartPointCard extends StatelessWidget {
  final VoidCallback onDirections;

  const StartPointCard({super.key, required this.onDirections});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 130,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _MapPainter())),
                const Align(
                  alignment: Alignment(0, -0.25),
                  child: Icon(
                    Icons.location_on,
                    size: 44,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نقطة الانطلاق',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'افتح الموقع في تطبيق الخرائط',
                        style: TextStyle(fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: onDirections,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 42),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.near_me_outlined, size: 18),
                  label: const Text('الاتجاهات'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// خلفية الخريطة: طرق + منطقة خضراء + مسار منقّط برتقالي
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEFEBE0),
    );

    // منطقة خضراء
    canvas.drawOval(
      Rect.fromLTWH(w * 0.62, -h * 0.25, w * 0.55, h * 0.8),
      Paint()..color = const Color(0xFFDCE8DC),
    );

    // طرق
    final road = Paint()
      ..color = const Color(0xFFD8D2C2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.75)
        ..cubicTo(w * 0.3, h * 0.55, w * 0.5, h * 0.95, w, h * 0.4),
      road,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.12, 0)
        ..quadraticBezierTo(w * 0.22, h * 0.5, w * 0.3, h),
      road,
    );

    // مسار منقّط
    final route = Path()
      ..moveTo(w * 0.52, h * 0.42)
      ..quadraticBezierTo(w * 0.72, h * 0.28, w * 0.95, h * 0.18);
    final dash = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final metric in route.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 6), dash);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}