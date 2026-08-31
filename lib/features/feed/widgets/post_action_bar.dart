import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../shared/models/post_model.dart';

/// Interactive action bar for post engagement (Likes, Comments, Share, Views, Bookmark).
class PostActionBar extends StatelessWidget {
  const PostActionBar({
    super.key,
    required this.post,
    required this.onLikeTap,
    required this.onBookmarkTap,
    this.onCommentTap,
    this.onShareTap,
  });

  final PostModel post;
  final VoidCallback onLikeTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left engagement actions
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Like Button & Count
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onLikeTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                    size: 18,
                    color: post.isLiked ? Colors.red : AppColors.bodyText,
                  ),
                  if (post.likesCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      '${post.likesCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.bodyText,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 18),
            // Comment Button & Count
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onCommentTap ?? () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 17,
                    color: AppColors.bodyText,
                  ),
                  if (post.commentsCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      '${post.commentsCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.bodyText,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 18),
            // Share Button
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onShareTap ?? () {},
              child: Transform.rotate(
                angle: -0.38, // ~ -22 degrees as in Figma
                child: const Icon(
                  Icons.send_outlined,
                  size: 17,
                  color: AppColors.bodyText,
                ),
              ),
            ),
          ],
        ),

        // Right actions (Views + Bookmark)
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (post.viewsCount > 0) ...[
              Text(
                post.viewsCount >= 1000
                    ? '${(post.viewsCount / 1000).toStringAsFixed(post.viewsCount % 1000 == 0 ? 0 : 1)}K Views'
                    : '${post.viewsCount} Views',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.bodyText,
                    ),
              ),
              const SizedBox(width: 16),
            ],
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBookmarkTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    post.isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                    size: 18,
                    color: post.isBookmarked ? AppColors.primaryGreen : AppColors.bodyText,
                  ),
                  if (post.bookmarksCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      '${post.bookmarksCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.bodyText,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
