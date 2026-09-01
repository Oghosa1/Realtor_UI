import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final Future<void> Function({
    required String content,
    required PostCategory category,
    PropertyTag? tag,
    String? location,
    File? image,
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
    final locationController = TextEditingController();
    PostCategory selectedCategory = PostCategory.request;
    PropertyTag? selectedTag = PropertyTag.lookingToBuy;
    XFile? pickedImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
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
                    
                    // Transaction Type Selector (only for Request or Property)
                    if (selectedCategory != PostCategory.general) ...[
                      Text(
                        'Transaction Type',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (selectedCategory == PostCategory.request) ...[
                            PropertyTag.lookingToBuy,
                            PropertyTag.lookingToRent,
                          ] else ...[
                            PropertyTag.forSale,
                            PropertyTag.forRent,
                          ]
                        ].map((tag) {
                          final isSelected = selectedTag == tag;
                          return ChoiceChip(
                            label: tag == PropertyTag.lookingToRent
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset('assets/images/key_icon.png', width: 16, height: 16),
                                      const SizedBox(width: 4),
                                      Text(tag.label),
                                    ],
                                  )
                                : Text(tag.label),
                            selected: isSelected,
                            selectedColor: AppColors.accentGreen.withValues(alpha: 0.3),
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.primaryGreen : AppColors.bodyText,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => selectedTag = tag);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                    ],

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
                    const SizedBox(height: 12),
                    
                    // Location Input
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Add location (e.g. Lekki Phase 1, Lagos)',
                        hintStyle: const TextStyle(color: AppColors.mutedText, fontSize: 14),
                        prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.mutedText),
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
                    const SizedBox(height: 12),

                    // Image Picker
                    if (pickedImage != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(pickedImage!.path),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => pickedImage = null),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() => pickedImage = image);
                          }
                        },
                        icon: const Icon(Icons.image_outlined, color: AppColors.primaryGreen),
                        label: const Text('Add Image', style: TextStyle(color: AppColors.primaryGreen)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryGreen),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        onPressed: isSubmitting ? null : () async {
                          if (textController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Post content cannot be empty')),
                            );
                            return;
                          }
                          
                          setState(() => isSubmitting = true);
                          try {
                            await onSubmitPost(
                              content: textController.text.trim(),
                              category: selectedCategory,
                              tag: selectedTag,
                              location: locationController.text.trim().isNotEmpty ? locationController.text.trim() : null,
                              image: pickedImage != null ? File(pickedImage!.path) : null,
                            );
                            if (context.mounted) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Post created successfully')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              setState(() => isSubmitting = false);
                            }
                          }
                        },
                        child: isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : const Text(
                                'Post',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

