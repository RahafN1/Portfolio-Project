import 'package:flutter/material.dart';

class ManageReviewsScreen extends StatefulWidget {
  const ManageReviewsScreen({super.key});

  @override
  State<ManageReviewsScreen> createState() => _ManageReviewsScreenState();
}

class _ManageReviewsScreenState extends State<ManageReviewsScreen> {
  // بيانات مؤقتة لين نربط الـ API
  final List<Map<String, dynamic>> _reviews = [
    {
      'user': 'نورة',
      'trail': 'مسار جبل السودة',
      'rating': 5,
      'comment': 'المسار ممتع والإطلالة من فوق تستاهل التعب.',
    },
    {
      'user': 'مستخدم123',
      'trail': 'مسار حافة العالم',
      'rating': 1,
      'comment': 'تعليق فيه ألفاظ مسيئة',
    },
  ];

  Future<void> _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف هذا التقييم؟'),
        content: const Text(
          'ينحذف التقييم لأنه مخالف لسياسة المحتوى، وما يقدر صاحبه يرجعه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _reviews.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review['user'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(review['trail'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < review['rating'] ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(review['comment']),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _confirmDelete(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('حذف التقييم',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}