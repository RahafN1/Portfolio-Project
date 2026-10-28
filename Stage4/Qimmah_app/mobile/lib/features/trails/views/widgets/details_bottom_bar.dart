import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

// الشريط الثابت أسفل الصفحة: "أكملت المسار" (يمين) و"محفوظ" (يسار)
// الزر المفعّل يصير أخضر معبّى، وغير المفعّل بإطار فقط
class DetailsBottomBar extends StatelessWidget {
  final bool isSaved;
  final bool isCompleted;
  final VoidCallback onSave;
  final VoidCallback onComplete;

  const DetailsBottomBar({
    super.key,
    required this.isSaved,
    required this.isCompleted,
    required this.onSave,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: _BarButton(
                  active: isCompleted,
                  icon: Icons.check,
                  label: isCompleted ? 'مكتمل' : 'أكملت المسار',
                  onTap: onComplete,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BarButton(
                  active: isSaved,
                  icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                  label: isSaved ? 'محفوظ' : 'حفظ',
                  onTap: onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final bool active;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BarButton({
    required this.active,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const size = Size.fromHeight(54);
    const shape = StadiumBorder();

    if (active) {
      return FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(minimumSize: size, shape: shape),
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: size,
        shape: shape,
        side: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}