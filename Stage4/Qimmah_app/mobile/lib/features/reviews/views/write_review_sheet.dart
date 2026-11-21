import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/l10n.dart';
import '../models/review.dart';
import '../viewmodels/reviews_viewmodel.dart';
import 'widgets/star_rating.dart';

// يفتح ورقة "اكتب تقييمك". يرجّع true لو اننشر أو تعدّل التقييم
// لو مررنا existingReview تصير الورقة ورقة تعديل
Future<bool?> showWriteReviewSheet(
  BuildContext context, {
  required ReviewsViewModel vm,
  required String trailName,
  Review? existingReview,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true, // عشان الكيبورد ما يغطي الحقل
    showDragHandle: true,
    builder: (_) => _WriteReviewSheet(
      vm: vm,
      trailName: trailName,
      existingReview: existingReview,
    ),
  );
}

class _WriteReviewSheet extends StatefulWidget {
  final ReviewsViewModel vm;
  final String trailName;
  final Review? existingReview; // null = تقييم جديد، غير كذا = تعديل

  const _WriteReviewSheet({
    required this.vm,
    required this.trailName,
    this.existingReview,
  });

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  final TextEditingController _controller = TextEditingController();
  int _rating = 0;
  bool _submitting = false;
  String? _error;

  // هل نحن في وضع التعديل؟
  bool get _isEditing => widget.existingReview != null;

  // الزر ينفتح لما نختار نجوم ونكتب تعليق
  bool get _canSubmit =>
      _rating > 0 && _controller.text.trim().isNotEmpty && !_submitting;

  @override
  void initState() {
    super.initState();
    // لو نعدّل، نعبّي النجوم والتعليق القديم
    final old = widget.existingReview;
    if (old != null) {
      _rating = old.rating;
      _controller.text = old.comment;
    }
  }

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

    // نختار الدالة حسب الوضع: تعديل أو نشر جديد
    final String? error = _isEditing
        ? await widget.vm.updateReview(
            review: widget.existingReview!,
            rating: _rating,
            comment: _controller.text,
          )
        : await widget.vm.submit(
            rating: _rating,
            comment: _controller.text,
          );

    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context, true); // اننشر أو تعدّل
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
            Text(
              context.l10n.reviewsWriteTitle,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              widget.trailName,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.reviewsYourRating,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            StarRating(
              rating: _rating,
              size: 40,
              onChanged: (value) => setState(() => _rating = value),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.reviewsYourComment,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 4,
              onChanged: (_) => setState(() {}), // يحدّث حالة الزر
              decoration: InputDecoration(
                hintText: context.l10n.reviewsCommentHint,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.hardFg)),
            ],
            const SizedBox(height: 16),
            PrimaryButton(
              text: context.l10n.reviewsPublish,
              isLoading: _submitting,
              onPressed: _canSubmit ? _submit : null,
            ),
            Center(
              child: TextButton(
                onPressed:
                    _submitting ? null : () => Navigator.pop(context, false),
                child: Text(context.l10n.reviewsCancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
