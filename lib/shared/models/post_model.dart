import 'user_model.dart';

/// Type of feed post.
enum PostCategory {
  request('Request'),
  general('General'),
  property('Property');

  const PostCategory(this.displayName);
  final String displayName;

  static PostCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'general':
        return PostCategory.general;
      case 'property':
        return PostCategory.property;
      case 'request':
      default:
        return PostCategory.request;
    }
  }
}

/// Tag associated with property posts or buyer/renter requests.
enum PropertyTag {
  lookingToBuy('Looking to Buy'),
  lookingToRent('Looking to Rent'),
  forRent('For Rent'),
  forSale('For Sale');

  const PropertyTag(this.label);
  final String label;

  static PropertyTag? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'looking to buy':
      case 'lookingtobuy':
        return PropertyTag.lookingToBuy;
      case 'looking to rent':
      case 'lookingtorent':
        return PropertyTag.lookingToRent;
      case 'for rent':
      case 'forrent':
        return PropertyTag.forRent;
      case 'for sale':
      case 'forsale':
        return PropertyTag.forSale;
      default:
        return null;
    }
  }
}

/// Preview comment structure.
class CommentModel {
  const CommentModel({
    required this.id,
    required this.authorHandle,
    required this.text,
    this.createdAt,
  });

  final String id;
  final String authorHandle;
  final String text;
  final DateTime? createdAt;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      authorHandle: json['authorHandle'] as String,
      text: json['text'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorHandle': authorHandle,
      'text': text,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

/// Main feed post model.
class PostModel {
  const PostModel({
    required this.id,
    required this.author,
    required this.category,
    this.tag,
    required this.content,
    this.location = 'Lekki Phase 1, Lagos',
    required this.timeAgo,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.viewsCount = 0,
    this.bookmarksCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    this.mediaUrl,
    this.isVideo = false,
    this.videoDuration,
    this.likedBy = const [],
    this.topComment,
    this.totalCommentsCount,
  });

  final String id;
  final UserModel author;
  final PostCategory category;
  final PropertyTag? tag;
  final String content;
  final String location;
  final String timeAgo;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final int bookmarksCount;
  final bool isLiked;
  final bool isBookmarked;
  final String? mediaUrl;
  final bool isVideo;
  final String? videoDuration;
  final List<UserModel> likedBy;
  final CommentModel? topComment;
  final int? totalCommentsCount;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
      category: PostCategory.fromString(json['category'] as String? ?? 'request'),
      tag: PropertyTag.fromString(json['tag'] as String?),
      content: json['content'] as String? ?? '',
      location: json['location'] as String? ?? 'Lekki Phase 1, Lagos',
      timeAgo: json['timeAgo'] as String? ?? 'Just Now',
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as int? ?? 0,
      bookmarksCount: json['bookmarksCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      mediaUrl: json['mediaUrl'] as String?,
      isVideo: json['isVideo'] as bool? ?? false,
      videoDuration: json['videoDuration'] as String?,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      topComment: json['topComment'] != null
          ? CommentModel.fromJson(json['topComment'] as Map<String, dynamic>)
          : null,
      totalCommentsCount: json['totalCommentsCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author.toJson(),
      'category': category.name,
      'tag': tag?.label,
      'content': content,
      'location': location,
      'timeAgo': timeAgo,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'viewsCount': viewsCount,
      'bookmarksCount': bookmarksCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'mediaUrl': mediaUrl,
      'isVideo': isVideo,
      'videoDuration': videoDuration,
      'likedBy': likedBy.map((e) => e.toJson()).toList(),
      'topComment': topComment?.toJson(),
      'totalCommentsCount': totalCommentsCount,
    };
  }

  PostModel copyWith({
    String? id,
    UserModel? author,
    PostCategory? category,
    PropertyTag? tag,
    String? content,
    String? location,
    String? timeAgo,
    int? likesCount,
    int? commentsCount,
    int? viewsCount,
    int? bookmarksCount,
    bool? isLiked,
    bool? isBookmarked,
    String? mediaUrl,
    bool? isVideo,
    String? videoDuration,
    List<UserModel>? likedBy,
    CommentModel? topComment,
    int? totalCommentsCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      author: author ?? this.author,
      category: category ?? this.category,
      tag: tag ?? this.tag,
      content: content ?? this.content,
      location: location ?? this.location,
      timeAgo: timeAgo ?? this.timeAgo,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isVideo: isVideo ?? this.isVideo,
      videoDuration: videoDuration ?? this.videoDuration,
      likedBy: likedBy ?? this.likedBy,
      topComment: topComment ?? this.topComment,
      totalCommentsCount: totalCommentsCount ?? this.totalCommentsCount,
    );
  }
}
