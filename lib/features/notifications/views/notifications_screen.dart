import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../viewmodel/notifications_viewmodel.dart';

/// Notifications screen displaying user alerts and activity.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Notifications${notificationsState.unreadCount > 0 ? ' (${notificationsState.unreadCount})' : ''}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_active_outlined, size: 64, color: AppColors.mutedText),
              const SizedBox(height: 12),
              Text(
                notificationsState.notifications.isEmpty 
                    ? 'No new notifications'
                    : 'You have ${notificationsState.notifications.length} notifications',
                style: const TextStyle(color: AppColors.mutedText, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
