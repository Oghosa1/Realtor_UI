import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../shared/models/post_model.dart';
import '../../../shared/widgets/custom_avatar.dart';

/// Post creation prompt input bar matching Figma specifications.
class CreatePostBar extends StatelessWidget {
  const CreatePostBar({
    super.key,
    required this.userAvatarUrl,
    required this.onSubmitPost,
  });

  final String userAvatarUrl;
  final Function({
    required String content,
    required PostCategory category,
    PropertyTag? tag,
  }) onSubmitPost;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
        onTap: () => _showCreatePostModal(context),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(888),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAvatar(
                imageUrl: userAvatarUrl,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Share a property, Make a request or say something...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedText,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    final textController = TextEditingController();
    PostCategory selectedCategory = PostCategory.request;
    PropertyTag? selectedTag = PropertyTag.lookingToBuy;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create Post',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Category Selector
                  Wrap(
                    spacing: 8,
                    children: PostCategory.values.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat.displayName),
                        selected: isSelected,
                        selectedColor: AppColors.accentGreen.withValues(alpha: 0.3),
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primaryGreen : AppColors.bodyText,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              selectedCategory = cat;
                              if (cat == PostCategory.general) {
                                selectedTag = null;
                              } else if (cat == PostCategory.request) {
                                selectedTag = PropertyTag.lookingToBuy;
                              } else {
                                selectedTag = PropertyTag.forRent;
                              }
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  // Text input
                  TextField(
                    controller: textController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'What would you like to share or request?',
                      hintStyle: const TextStyle(color: AppColors.mutedText, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryGreen),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (textController.text.trim().isNotEmpty) {
                          onSubmitPost(
                            content: textController.text.trim(),
                            category: selectedCategory,
                            tag: selectedTag,
                          );
                          Navigator.pop(ctx);
                        }
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
