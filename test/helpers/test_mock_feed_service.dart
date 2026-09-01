import 'dart:io';
import 'package:expert_listing/shared/models/post_model.dart';
import 'package:expert_listing/shared/models/story_model.dart';
import 'package:expert_listing/shared/models/user_model.dart';
import 'package:expert_listing/shared/services/feed_service.dart';

/// Test-only mock implementation of [FeedService] used strictly inside test suites.
class TestMockFeedService implements FeedService {
  TestMockFeedService({
    List<StoryModel>? stories,
    List<PostModel>? posts,
  })  : _stories = stories ??
            [
              const StoryModel(
                id: 'story_0',
                user: UserModel(
                  id: 'user_current',
                  name: 'Your Story',
                  avatarUrl: 'https://example.com/avatar.jpg',
                ),
                isMyStory: true,
              ),
            ],
        _posts = posts ??
            [
              const PostModel(
                id: 'post_1',
                author: UserModel(
                  id: 'author_1',
                  name: 'Felix Okon',
                  avatarUrl: 'https://example.com/felix.jpg',
                ),
                category: PostCategory.request,
                tag: PropertyTag.lookingToBuy,
                content: 'Looking for a 2-bedroom apartment in Yaba',
                timeAgo: 'Just Now',
                likesCount: 1,
              ),
              const PostModel(
                id: 'post_2',
                author: UserModel(
                  id: 'author_2',
                  name: 'Maurice U',
                  avatarUrl: 'https://example.com/maurice.jpg',
                ),
                category: PostCategory.property,
                tag: PropertyTag.forSale,
                content: 'Luxury 3-bedroom flat for sale in Lekki',
                timeAgo: '2h',
                likesCount: 5,
              ),
            ];

  final List<StoryModel> _stories;
  final List<PostModel> _posts;

  @override
  Future<List<StoryModel>> getStories() async => List.unmodifiable(_stories);

  @override
  Future<List<PostModel>> getPosts({String? filter, int limit = 10, int page = 1}) async {
    if (filter == null || filter == 'All') return List.unmodifiable(_posts);
    return _posts.where((p) {
      if (filter == 'Requests') return p.category == PostCategory.request;
      if (filter == 'Properties') return p.category == PostCategory.property;
      return true;
    }).toList();
  }

  @override
  Future<PostModel> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    final post = _posts[index];
    final updated = post.copyWith(
      isLiked: !post.isLiked,
      likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
    );
    _posts[index] = updated;
    return updated;
  }

  @override
  Future<PostModel> toggleBookmark(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    final post = _posts[index];
    final updated = post.copyWith(isBookmarked: !post.isBookmarked);
    _posts[index] = updated;
    return updated;
  }

  @override
  Future<PostModel> createPost({
    required String content,
    required PostCategory category,
    PropertyTag? tag,
    String? location,
    File? image,
  }) async {
    final newPost = PostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      author: const UserModel(id: 'me', name: 'Your Story', avatarUrl: ''),
      category: category,
      tag: tag,
      content: content,
      timeAgo: 'Just Now',
    );
    _posts.insert(0, newPost);
    return newPost;
  }

  @override
  Future<List<CommentModel>> getComments(String postId) async => [];

  @override
  Future<CommentModel> addComment(String postId, String text) async {
    return CommentModel(id: 'com_1', authorHandle: 'user', text: text);
  }
}
