import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../shared/models/post_model.dart';
import '../../../shared/widgets/custom_avatar.dart';
import '../../../shared/widgets/overlapping_avatars.dart';
import '../../../shared/widgets/shimmer_skeleton.dart';
import '../../../shared/widgets/tag_badge.dart';
import 'post_action_bar.dart';

/// Post card component supporting Requests, Discussions, and Property listings.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    required this.onBookmarkTap,
    this.onCommentTap,
    this.onShareTap,
    this.onMoreTap,
  });

  final PostModel post;
  final VoidCallback onLikeTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Avatar
          CustomAvatar(
            imageUrl: post.author.avatarUrl,
            name: post.author.name,
            size: 40,
            hasStoryRing: post.author.role != null,
            storyRingColor: AppColors.accentGreen,
          ),
          const SizedBox(width: 8),

          // Main post body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Author, Role, Category, Time, More options)
                _buildHeader(context),
                const SizedBox(height: 8),

                // Post Content Text
                Text(
                  post.content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkText,
                        height: 1.3,
                      ),
                ),
                const SizedBox(height: 8),

                // Location & Tag row (if available)
                if (post.location.isNotEmpty || post.tag != null) ...[
                  _buildLocationAndTag(context),
                  const SizedBox(height: 10),
                ],

                // Media display (Image / Video)
                if (post.mediaUrl != null && post.mediaUrl!.isNotEmpty) ...[
                  _buildMedia(context),
                  const SizedBox(height: 12),
                ],

                // Action Bar (Likes, Comments, Share, Views, Bookmark)
                PostActionBar(
                  post: post,
                  onLikeTap: onLikeTap,
                  onBookmarkTap: onBookmarkTap,
                  onCommentTap: onCommentTap,
                  onShareTap: onShareTap,
                ),
                const SizedBox(height: 10),

                // Liked By row
                if (post.likedBy.isNotEmpty || post.likesCount > 0) ...[
                  OverlappingAvatars(
                    users: post.likedBy,
                    totalLikesCount: post.likesCount,
                  ),
                  const SizedBox(height: 8),
                ],

                // Preview Comment (for discussion posts)
                if (post.topComment != null) ...[
                  _buildTopComment(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author name & optional role
              Row(
                children: [
                  Flexible(
                    child: Text(
                      post.author.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkText,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (post.author.role != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.dotSeparator,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.author.role!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: AppColors.mutedText,
                          ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              // Category & Time
              Row(
                children: [
                  Text(
                    post.category.displayName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: AppColors.mutedText,
                        ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.dotSeparator,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    post.timeAgo,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: AppColors.mutedText,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.more_horiz_rounded,
            size: 20,
            color: AppColors.darkText,
          ),
          onPressed: onMoreTap ?? () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildLocationAndTag(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (post.location.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.bodyText,
              ),
              const SizedBox(width: 4),
              Text(
                post.location,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.bodyText,
                    ),
              ),
            ],
          )
        else
          const SizedBox.shrink(),
        if (post.tag != null) TagBadge(tag: post.tag!),
      ],
    );
  }

  Widget _buildMedia(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: post.mediaUrl!,
            width: double.infinity,
            height: post.isVideo ? 380 : 240,
            fit: BoxFit.cover,
            placeholder: (context, url) => ShimmerSkeleton(
              height: post.isVideo ? 380 : 240,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: AppColors.feedBackground,
              child: const Icon(Icons.image_not_supported_outlined, color: AppColors.mutedText),
            ),
          ),
          if (post.isVideo) ...[
            // Centered Play button
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.mediaOverlay,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.surface,
                size: 28,
              ),
            ),
            // Bottom-left duration pill
            if (post.videoDuration != null)
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.mediaOverlay,
                    borderRadius: BorderRadius.circular(888),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.surface,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.videoDuration!,
                        style: const TextStyle(
                          color: AppColors.surface,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopComment(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${post.topComment!.authorHandle} ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                      fontSize: 14,
                    ),
              ),
              TextSpan(
                text: post.topComment!.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkText,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
        if (post.totalCommentsCount != null && post.totalCommentsCount! > 0) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onCommentTap ?? () {},
            child: Text(
              'View all ${post.totalCommentsCount} comments',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedText,
                    fontSize: 13,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
