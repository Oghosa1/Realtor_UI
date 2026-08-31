import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../shared/models/story_model.dart';
import '../../../shared/widgets/custom_avatar.dart';

/// Horizontally scrollable stories bar matching Figma specifications.
class StoriesCarousel extends StatelessWidget {
  const StoriesCarousel({
    super.key,
    required this.stories,
    this.onStoryTap,
    this.onAddStoryTap,
  });

  final List<StoryModel> stories;
  final ValueChanged<StoryModel>? onStoryTap;
  final VoidCallback? onAddStoryTap;

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 96,
      color: AppColors.surface,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        itemCount: stories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final story = stories[index];
          return _buildStoryItem(context, story);
        },
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, StoryModel story) {
    final isYourStory = story.isMyStory;
    final displayName = isYourStory ? 'Your Story' : story.user.name;

    return GestureDetector(
      onTap: () {
        if (isYourStory && onAddStoryTap != null) {
          onAddStoryTap!();
        } else if (onStoryTap != null) {
          onStoryTap!(story);
        }
      },
      child: SizedBox(
        width: 66,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAvatar(
              imageUrl: story.user.avatarUrl,
              name: story.user.name,
              size: 58,
              hasStoryRing: !isYourStory && story.hasUnseenStory,
              storyRingColor: AppColors.accentGreen,
              isYourStory: isYourStory,
            ),
            const SizedBox(height: 4),
            Text(
              displayName,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.bodyText,
                    fontSize: 12,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
