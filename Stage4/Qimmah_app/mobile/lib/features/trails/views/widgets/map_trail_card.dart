import 'package:flutter/material.dart';

// ../../../../ = نطلع 4 مجلدات (widgets ← views ← trails ← features) لين نوصل lib
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
// ../../ = نطلع لـ trails، وبعدها ندخل models
import '../../models/trail.dart';

// الكرت اللي يطلع تحت لما نضغط على علامة مسار
class MapTrailCard extends StatelessWidget {
  final Trail trail; // المسار اللي نعرضه
  final bool isOnTrail; // هل المستخدم بدأ المسار؟
  final VoidCallback onClose; // زر X
  final VoidCallback onDirections; // زر الاتجاهات
  final VoidCallback onStart; // زر ابدأ المسار
  final VoidCallback onDetails; // زر عرض التفاصيل

  const MapTrailCard({
    super.key,
    required this.trail,
    this.isOnTrail = false, // افتراضياً: ما بدأ
    required this.onClose,
    required this.onDirections,
    required this.onStart,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16), // مسافة من أطراف الشاشة
      padding: const EdgeInsets.all(14), // مسافة داخل الكرت
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // الكرت بطول محتواه بس
        children: [
          // ---------- الجزء الأول: الصورة + المعلومات + X ----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المسار (بالعربي تجي يمين)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _cover(),
              ),
              const SizedBox(width: 12),

              // المعلومات تاخذ المساحة الباقية
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المسار
                    Text(
                      trail.name,
                      maxLines: 2, // سطرين بالكثير
                      overflow: TextOverflow.ellipsis, // لو أطول نحط ...
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // المنطقة
                    Text(
                      trail.region,
                      style: const TextStyle(fontSize: 12, color: AppColors.grey),
                    ),
                    const SizedBox(height: 8),
                    // الصعوبة + المسافة والمدة
                    Row(
                      children: [
                        _DifficultyChip(
                          difficulty: trail.difficulty,
                          label: trail.difficultyArabic,
                        ),
                        const SizedBox(width: 8),
                        // Flexible: النص ياخذ المكان الباقي بس، ولو طويل يقص
                        Flexible(
                          child: Text(
                            '${trail.distanceText} كم · ${trail.estimatedDuration}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // زر X (بالعربي يجي يسار)
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 20),
                visualDensity: VisualDensity.compact, // زر أصغر
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ---------- الجزء الثاني: الأزرار ----------
          Row(
            children: [
              // الاتجاهات (أخضر فاتح)
              Expanded(
                child: FilledButton.icon(
                  onPressed: onDirections,
                  icon: const Icon(Icons.near_me_outlined, size: 16),
                  label: const _ButtonText(AppStrings.mapDirections),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                ),
              ),

              // ابدأ المسار (أخضر غامق) — يختفي لو المستخدم بدأ
              if (!isOnTrail) ...[
                const SizedBox(width: 6),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onStart,
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: const _ButtonText(AppStrings.mapStartTrail),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 6),

              // عرض التفاصيل (أبيض بإطار)
              Expanded(
                child: OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                  child: const _ButtonText(AppStrings.mapViewDetails),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // صورة المسار، ولو ما فيه صورة نحط أيقونة جبل
  Widget _cover() {
    const size = 80.0;
    final placeholder = Container(
      width: size,
      height: size,
      color: AppColors.primaryLight,
      child: const Icon(Icons.landscape, color: AppColors.primary),
    );

    if (trail.coverImage == null) return placeholder;

    return Image.network(
      trail.coverImage!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      // لو الصورة ما فتحت (مثلاً النت فصل) نطلع الأيقونة
      errorBuilder: (context, error, stack) => placeholder,
    );
  }
}

// نص الزر: يصغر لحاله لو المكان ضيق بدل ما يطلع برّا
class _ButtonText extends StatelessWidget {
  final String text;

  const _ButtonText(this.text);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown, // يصغّر النص بس، ما يكبّره
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// شارة الصعوبة: لونها يتغيّر حسب سهل/متوسط/صعب
class _DifficultyChip extends StatelessWidget {
  final String difficulty; // easy أو moderate أو hard
  final String label; // سهل أو متوسط أو صعب

  const _DifficultyChip({required this.difficulty, required this.label});

  @override
  Widget build(BuildContext context) {
    // نختار اللون حسب الصعوبة
    Color color;
    if (difficulty == 'easy') {
      color = AppColors.primary; // أخضر
    } else if (difficulty == 'hard') {
      color = AppColors.orange; // برتقالي
    } else {
      color = const Color(0xFF3B6BB5); // أزرق للمتوسط
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12), // نفس اللون بس فاتح
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // النقطة الصغيرة
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}