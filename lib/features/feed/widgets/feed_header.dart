import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';

/// Top navigation header with official Expert Listing logo on the left and message button on the right.
class FeedHeader extends StatelessWidget {
  const FeedHeader({
    super.key,
    this.onMessageTap,
  });

  final VoidCallback? onMessageTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Official Brand Logo on the left
          Image.asset(
            AppConstants.logoPath,
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.apartment,
                    color: AppColors.surface,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Expert Listing',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
          ),

          // Envelope / Message Button on the right
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.iconButtonBackground,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.mail_outline_rounded,
                size: 20,
                color: AppColors.bodyText,
              ),
              onPressed: onMessageTap ?? () {},
              splashRadius: 22,
            ),
          ),
        ],
      ),
    );
  }
}
