import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// Bottom navigation bar matching the exact Figma layout, spacing, and styling.
class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.borderLight,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(
                    context: context,
                    index: 0,
                    label: 'Feed',
                    iconPath: 'assets/images/nav/home.png',
                  ),
                  _buildNavItem(
                    context: context,
                    index: 1,
                    label: 'Search',
                    iconPath: 'assets/images/nav/search.png',
                  ),
                  _buildNavItem(
                    context: context,
                    index: 2,
                    label: 'List',
                    iconPath: 'assets/images/nav/list.png',
                  ),
                  _buildNavItem(
                    context: context,
                    index: 3,
                    label: 'Notification',
                    iconPath: 'assets/images/nav/notification.png',
                  ),
                  _buildNavItem(
                    context: context,
                    index: 4,
                    label: 'Profile',
                    iconPath: 'assets/images/nav/profile.png',
                  ),
                ],
              ),
              if (bottomPadding == 0) ...[
                const SizedBox(height: 8),
                Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.darkText,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String label,
    required String iconPath,
  }) {
    final isSelected = currentIndex == index;
    final itemColor = isSelected ? AppColors.navActiveGreen : AppColors.bodyText;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 58,
        height: 52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(iconPath),
              size: 24,
              color: itemColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: itemColor,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
