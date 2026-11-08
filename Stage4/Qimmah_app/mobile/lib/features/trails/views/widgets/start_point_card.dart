import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';

// كرت نقطة البداية: خريطة حقيقية على إحداثيات المسار + زر "الاتجاهات"
class StartPointCard extends StatelessWidget {
  final LatLng point; // إحداثيات نقطة البداية
  final List<LatLng> route; // نقاط خط المسار (ممكن تكون فاضية)
  final VoidCallback onDirections;
  final VoidCallback? onMapTap; // الضغط على الخريطة (يفتح التتبّع)

  const StartPointCard({
    super.key,
    required this.point,
    this.route = const [],
    required this.onDirections,
    this.onMapTap,
  });

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
            height: 160,
            width: double.infinity,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: point,
                initialZoom: 14,
                onTap: onMapTap == null ? null : (_, __) => onMapTap!(),
                // لو فيه مسار نضبط الكاميرا عشان يبان كله
                initialCameraFit: route.length >= 2
                    ? CameraFit.coordinates(
                        coordinates: route,
                        padding: const EdgeInsets.all(28),
                      )
                    : null,
                // خريطة للعرض فقط (ما تتحرك ولا تتكبر)
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.qimmah.app',
                ),
                // شكل المسار (برتقالي)
                if (route.length >= 2)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: route,
                        strokeWidth: 4,
                        color: AppColors.accent,
                        strokeCap: StrokeCap.round,
                        strokeJoin: StrokeJoin.round,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter, // رأس الدبوس على النقطة
                      child: const Icon(
                        Icons.location_on,
                        size: 44,
                        color: AppColors.accent, // برتقالي
                      ),
                    ),
                  ],
                ),
                // ذكر مصدر الخريطة (شرط من OpenStreetMap)
              RichAttributionWidget(
  attributions: [
    TextSourceAttribution('OpenStreetMap contributors'),
  ],
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