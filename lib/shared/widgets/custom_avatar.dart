import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// Customizable circular avatar widget matching Figma specs.
class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    super.key,
    required this.imageUrl,
    this.name,
    this.size = 40,
    this.hasStoryRing = false,
    this.storyRingColor = AppColors.accentGreen,
    this.isYourStory = false,
    this.isOnline = false,
    this.onTap,
  });

  final String imageUrl;
  final String? name;
  final double size;
  final bool hasStoryRing;
  final Color storyRingColor;
  final bool isYourStory;
  final bool isOnline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget avatarImage = ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: size,
                height: size,
                color: const Color(0xFFD0CBDD),
                child: Center(
                  child: Text(
                    name?.isNotEmpty == true ? name![0].toUpperCase() : '',
                    style: TextStyle(
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodyText,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: size,
                height: size,
                color: const Color(0xFFD0CBDD),
                child: Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: AppColors.bodyText,
                ),
              ),
            )
          : Container(
              width: size,
              height: size,
              color: const Color(0xFFD0CBDD),
              child: Icon(
                Icons.person,
                size: size * 0.5,
                color: AppColors.bodyText,
              ),
            ),
    );

    if (hasStoryRing) {
      avatarImage = Container(
        width: size + 4,
        height: size + 4,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: storyRingColor,
            width: 2,
          ),
        ),
        child: avatarImage,
      );
    }

    Widget content = Stack(
      clipBehavior: Clip.none,
      children: [
        avatarImage,
        if (isYourStory)
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.accentGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 14,
                  color: AppColors.darkText,
                ),
              ),
            ),
          ),
        if (isOnline && !isYourStory)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.accentGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
