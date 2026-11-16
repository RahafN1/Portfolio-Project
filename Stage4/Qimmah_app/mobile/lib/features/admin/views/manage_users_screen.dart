import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/l10n.dart';
import '../models/admin_models.dart';
import '../viewmodels/admin_viewmodel.dart';
import 'widgets/admin_helpers.dart';

// تبويب المستخدمين: إيقاف وإلغاء إيقاف
class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  Future<void> _onToggle(BuildContext context, AdminUser user) async {
    final suspending = !user.isSuspended;

    // الإيقاف يحتاج تأكيد، وإلغاء الإيقاف مباشر
    if (suspending) {
      final confirmed = await showConfirmDialog(
        context,
        title: context.l10n.adminSuspendUserTitle,
        message: context.l10n.adminSuspendUserMessage,
        confirmText: context.l10n.adminSuspend,
      );
      if (!confirmed || !context.mounted) return;
    }

    final ok = await context.read<AdminViewModel>().toggleSuspend(user);
    if (!context.mounted) return;
    showAdminToast(
      context,
      !ok
          ? context.l10n.adminGenericError
          : suspending
              ? context.l10n.adminUserSuspended(user.name)
              : context.l10n.adminUserUnsuspended(user.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();

    if (vm.users.isEmpty) {
      return Center(child: Text(context.l10n.adminNoUsers));
    }

    return RefreshIndicator(
      onRefresh: () => vm.load(silent: true),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: vm.users.length,
        itemBuilder: (context, index) {
          final user = vm.users[index];
          final suspended = user.isSuspended;
          final initial =
              user.name.isEmpty ? '?' : user.name.characters.first;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      suspended ? AppColors.hardBg : AppColors.primaryLight,
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: suspended ? adminDanger : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusChip(suspended: suspended),
                        ],
                      ),
                      Text(
                        user.email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.grey),
                      ),
                      Text(
                        context.l10n.adminUserReviewsCount(user.reviewsCount),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // الثيم يخلي الزر بعرض لا نهائي، فنصغّره
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    backgroundColor: Colors.transparent,
                    foregroundColor: suspended ? null : adminDanger,
                    side: BorderSide(
                      color: suspended ? AppColors.border : adminDanger,
                    ),
                  ),
                  onPressed: () => _onToggle(context, user),
                  child: Text(suspended
                      ? context.l10n.adminUnsuspend
                      : context.l10n.adminSuspend),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// شارة "نشط" أو "موقوف"
class _StatusChip extends StatelessWidget {
  final bool suspended;

  const _StatusChip({required this.suspended});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: suspended ? AppColors.hardBg : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        suspended
            ? context.l10n.adminStatusSuspended
            : context.l10n.adminStatusActive,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: suspended ? adminDanger : AppColors.primary,
        ),
      ),
    );
  }
}