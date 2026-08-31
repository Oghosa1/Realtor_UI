import 'package:flutter/material.dart';
import '../../../core/theme.dart';

/// Notifications screen displaying user alerts and activity.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: const SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_active_outlined, size: 64, color: AppColors.mutedText),
              SizedBox(height: 12),
              Text(
                'No new notifications',
                style: TextStyle(color: AppColors.mutedText, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
