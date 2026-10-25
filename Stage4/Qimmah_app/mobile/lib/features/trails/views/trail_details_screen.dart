import 'package:flutter/material.dart';

import '../models/trail.dart';

// صفحة تفاصيل المسار
class TrailDetailsScreen extends StatelessWidget {
  final Trail trail; // المسار اللي ضغط عليه اليوزر

  const TrailDetailsScreen({super.key, required this.trail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopImage(context),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 20),
                  _buildStats(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== الصورة العلوية =====
  Widget _buildTopImage(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          // الصورة نفسها
          Positioned.fill(
            child: trail.coverImage != null
                ? Image.network(
                    trail.coverImage!,
                    fit: BoxFit.cover,
                    // لو الصورة ما تحمّلت نعرض خلفية بدالها
                    errorBuilder: (context, error, stack) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),

          // زر الرجوع
          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // شارة "معتمد" (تطلع بس إذا المسار معتمد)
          if (trail.isCertified)
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: Color(0xFF1F5233)),
                    SizedBox(width: 4),
                    Text(
                      'معتمد',
                      style: TextStyle(
                        color: Color(0xFF1F5233),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // خلفية بديلة لو ما فيه صورة
  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFE3EEE6),
      child: const Icon(Icons.landscape, size: 64, color: Color(0xFF1F5233)),
    );
  }

  // ===== الاسم والتقييم والمنطقة =====
  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // الاسم ياخذ المساحة الباقية
            Expanded(
              child: Text(
                trail.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.star, color: Color(0xFFC97B47), size: 20),
            const SizedBox(width: 4),
            Text(
              // لو ما فيه تقييم نكتب "جديد"
              trail.averageRating?.toStringAsFixed(1) ?? 'جديد',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text(trail.region, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  // ===== الكروت الثلاثة =====
  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(Icons.route, '${trail.distanceText} كم', 'المسافة'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            Icons.access_time,
            trail.estimatedDuration.isEmpty ? '-' : trail.estimatedDuration,
            'المدة المتوقعة',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            Icons.terrain,
            trail.difficultyArabic,
            'الصعوبة',
            highlight: true, // كرت الصعوبة لونه مختلف
          ),
        ),
      ],
    );
  }

  // كرت واحد (نستخدمه ثلاث مرات)
  Widget _statCard(IconData icon, String value, String label,
      {bool highlight = false}) {
    final color = highlight ? const Color(0xFFC97B47) : const Color(0xFF1F5233);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFF7E6DA) : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: highlight ? color : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}