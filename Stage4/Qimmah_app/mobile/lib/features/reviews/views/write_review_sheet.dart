import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../viewmodels/reviews_viewmodel.dart';
import 'widgets/star_rating.dart';

// يفتح ورقة "اكتب تقييمك". يرجّع true لو اننشر التقييم
Future<bool?> showWriteReviewSheet(
  BuildContext context, {
  required ReviewsViewModel vm,
  required String trailName,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true, // عشان الكيبورد ما يغطي الحقل
    showDragHandle: true,
    builder: (_) => _WriteReviewSheet(vm: vm, trailName: trailName),
  );
}

class _WriteReviewSheet extends StatefulWidget {
  final ReviewsViewModel vm;
  final String trailName;

  const _WriteReviewSheet({required this.vm, required this.trailName});

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  final TextEditingController _controller = TextEditingController();
  int _rating = 0;
  bool _submitting = false;
  String? _error;

  // الزر ينفتح لما نختار نجوم ونكتب تعليق
  bool get _canSubmit =>
      _rating > 0 && _controller.text.trim().isNotEmpty && !_submitting;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final error = await widget.vm.submit(
      rating: _rating,
      comment: _controller.text,
    );
    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context, true); // اننشر
    } else {
      setState(() {
        _submitting = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ارتفاع الكيبورد، عشان نرفع المحتوى فوقه
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + keyboard),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اكتب تقييمك',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              widget.trailName,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            const Text(
              'تقييمك للمسار',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            StarRating(
              rating: _rating,
              size: 40,
              onChanged: (value) => setState(() => _rating = value),
            ),
            const SizedBox(height: 20),
            const Text(
              'تعليقك',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 4,
              onChanged: (_) => setState(() {}), // يحدّث حالة الزر
              decoration: const InputDecoration(
                hintText: 'شاركنا تجربتك في المسار...',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.hardFg)),
            ],
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'نشر التقييم',
              isLoading: _submitting,
              onPressed: _canSubmit ? _submit : null,
            ),
            Center(
              child: TextButton(
                onPressed:
                    _submitting ? null : () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
الورقة تنفتح فوق الصفحة،
 مو داخلها، فما تشوف الـ Provider حق الصفحة. لهذا نمرر الـ ViewModel لها يدوياً.
*/