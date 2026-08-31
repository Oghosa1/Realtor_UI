import 'user_model.dart';

/// Story model for horizontal carousel.
class StoryModel {
  const StoryModel({
    required this.id,
    required this.user,
    this.isMyStory = false,
    this.hasUnseenStory = true,
    this.mediaUrl,
    this.createdAt,
  });

  final String id;
  final UserModel user;
  final bool isMyStory;
  final bool hasUnseenStory;
  final String? mediaUrl;
  final DateTime? createdAt;

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      isMyStory: json['isMyStory'] as bool? ?? false,
      hasUnseenStory: json['hasUnseenStory'] as bool? ?? true,
      mediaUrl: json['mediaUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'isMyStory': isMyStory,
      'hasUnseenStory': hasUnseenStory,
      'mediaUrl': mediaUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  StoryModel copyWith({
    String? id,
    UserModel? user,
    bool? isMyStory,
    bool? hasUnseenStory,
    String? mediaUrl,
    DateTime? createdAt,
  }) {
    return StoryModel(
      id: id ?? this.id,
      user: user ?? this.user,
      isMyStory: isMyStory ?? this.isMyStory,
      hasUnseenStory: hasUnseenStory ?? this.hasUnseenStory,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
