import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../models/user_model.dart';
import 'custom_avatar.dart';

/// Overlapping avatars row for like acknowledgments matching Figma specifications.
class OverlappingAvatars extends StatelessWidget {
  const OverlappingAvatars({
    super.key,
    required this.users,
    this.totalLikesCount,
    this.size = 24,
    this.overlap = 6,
  });

  final List<UserModel> users;
  final int? totalLikesCount;
  final double size;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox.shrink();

    final displayUsers = users.take(3).toList();
    final firstUser = users.first;
    final totalLikes = totalLikesCount ?? users.length;
    final otherCount = totalLikes - 1;

    String labelText;
    if (otherCount <= 0) {
      labelText = 'Liked by ${firstUser.name}';
    } else {
      labelText = 'Liked by ${firstUser.name} and $otherCount ${otherCount == 1 ? 'other' : 'others'}';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size,
          width: displayUsers.length == 1
              ? size
              : size + (displayUsers.length - 1) * (size - overlap),
          child: Stack(
            children: [
              for (int i = 0; i < displayUsers.length; i++)
                Positioned(
                  left: i * (size - overlap),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 2,
                      ),
                    ),
                    child: CustomAvatar(
                      imageUrl: displayUsers[i].avatarUrl,
                      name: displayUsers[i].name,
                      size: size - 4,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            labelText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.bodyText,
                  fontSize: 14,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
