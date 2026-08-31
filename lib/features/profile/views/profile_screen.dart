import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../shared/widgets/custom_avatar.dart';

/// User profile screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Profile',
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
            children: [
              const SizedBox(height: 24),
              const CustomAvatar(
                imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&fit=crop',
                size: 80,
              ),
              const SizedBox(height: 12),
              Text(
                'Your Profile',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Real Estate Enthusiast & Broker',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mutedText,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
