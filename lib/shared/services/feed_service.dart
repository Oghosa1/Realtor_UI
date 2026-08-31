import 'dart:async';
import '../models/post_model.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';

/// Abstract service interface for feed data operations.
/// This contract will remain unchanged when transitioning to the Node.js backend.
abstract class FeedService {
  Future<List<StoryModel>> getStories();
  Future<List<PostModel>> getPosts({String? filter});
  Future<PostModel> toggleLike(String postId);
  Future<PostModel> toggleBookmark(String postId);
  Future<PostModel> createPost({
    required String content,
    required PostCategory category,
    PropertyTag? tag,
    String? location,
    String? mediaUrl,
  });
}

/// In-memory mock implementation of [FeedService] providing sample data matching Figma.
class MockFeedService implements FeedService {
  MockFeedService() {
    _initializeData();
  }

  late List<StoryModel> _stories;
  late List<PostModel> _posts;

  static const UserModel _currentUser = UserModel(
    id: 'user_current',
    name: 'Your Story',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&fit=crop',
  );

  static const UserModel _miracle = UserModel(
    id: 'user_miracle',
    name: 'miracle.h',
    handle: 'miracle.h',
    avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&fit=crop',
  );

  static const UserModel _dirk = UserModel(
    id: 'user_dirk',
    name: 'Dirk Horton',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop',
  );

  static const UserModel _scott = UserModel(
    id: 'user_scott',
    name: 'Scott Lyons',
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&fit=crop',
  );

  static const UserModel _bryn = UserModel(
    id: 'user_bryn',
    name: 'Bryn Booker',
    avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&fit=crop',
  );

  void _initializeData() {
    _stories = [
      const StoryModel(
        id: 'story_0',
        user: _currentUser,
        isMyStory: true,
        hasUnseenStory: false,
      ),
      const StoryModel(
        id: 'story_1',
        user: UserModel(
          id: 'user_1',
          name: 'RamosRealty',
          avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_2',
        user: UserModel(
          id: 'user_2',
          name: 'Jordan',
          avatarUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_3',
        user: UserModel(
          id: 'user_3',
          name: 'Taylor',
          avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_4',
        user: UserModel(
          id: 'user_4',
          name: 'Jamie',
          avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_5',
        user: UserModel(
          id: 'user_5',
          name: 'Jordan',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_6',
        user: UserModel(
          id: 'user_6',
          name: 'EmersonJohn Thomaos',
          avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_7',
        user: UserModel(
          id: 'user_7',
          name: 'Sydney',
          avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_8',
        user: UserModel(
          id: 'user_8',
          name: 'Quinn',
          avatarUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_9',
        user: UserModel(
          id: 'user_9',
          name: 'Parker',
          avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=200&fit=crop',
        ),
      ),
      const StoryModel(
        id: 'story_10',
        user: UserModel(
          id: 'user_10',
          name: 'Hayden',
          avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&fit=crop',
        ),
      ),
    ];

    _posts = [
      const PostModel(
        id: 'post_1',
        author: UserModel(
          id: 'author_felix',
          name: 'Felix Okon',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop',
        ),
        category: PostCategory.request,
        tag: PropertyTag.lookingToBuy,
        content:
            'Looking for a 2-bedroom apartment in Yaba or Akoka. Must have constant water and parking for one car. Moving in by end of next month.rviced 3-bedroom apartment with fitted kitchen, parking for 3 cars, and 24/7 power. Inspection opens this Saturday.',
        location: 'Lekki Phase 1, Lagos',
        timeAgo: 'Just Now',
        likesCount: 1,
        commentsCount: 0,
        likedBy: [_miracle],
      ),
      const PostModel(
        id: 'post_2',
        author: UserModel(
          id: 'author_maurice',
          name: 'Maurice U',
          avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&fit=crop',
        ),
        category: PostCategory.general,
        content:
            'How is everyone holding up with the flooding in Lekki this week? Stay safe out there — and let me know if anyone needs a temporary place to crash 🙏',
        location: 'Lekki Phase 1, Lagos',
        timeAgo: 'Just Now',
        likesCount: 8,
        commentsCount: 8,
        viewsCount: 700,
        bookmarksCount: 2,
        likedBy: [_dirk, _scott, _bryn],
        topComment: CommentModel(
          id: 'com_1',
          authorHandle: 'tunde_b',
          text: 'Roads around Admiralty are still bad. Thanks for checking in 🙏',
        ),
        totalCommentsCount: 7,
      ),
      const PostModel(
        id: 'post_3',
        author: UserModel(
          id: 'author_boyd',
          name: 'Boyd From',
          role: 'Developer',
          avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&fit=crop',
        ),
        category: PostCategory.property,
        tag: PropertyTag.forRent,
        content:
            'Newly serviced 3-bedroom apartment with fitted kitchen, parking for 3 cars, and 24/7 power. Inspection opens this Saturday.',
        location: 'Lekki Phase 1, Lagos',
        timeAgo: '2h',
        mediaUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&fit=crop',
        likesCount: 23,
        commentsCount: 0,
        viewsCount: 1000,
        bookmarksCount: 2,
        likedBy: [_dirk, _scott, _bryn],
      ),
      const PostModel(
        id: 'post_4',
        author: UserModel(
          id: 'author_felix_broker',
          name: 'Felix Okon',
          role: 'Broker',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop',
        ),
        category: PostCategory.property,
        tag: PropertyTag.forSale,
        content:
            'New 2-bedroom apartment in Yaba or Akoka. Must have constant water and parking for one car. Moving in by end of next month.rviced 3-bedroom apartment with fitted kitchen, parking for 3 cars, and 24/7 power. Inspection opens this Saturday.',
        location: 'Lekki Phase 1, Lagos',
        timeAgo: 'Just Now',
        mediaUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&fit=crop',
        isVideo: true,
        videoDuration: '0:20',
        likesCount: 1,
        viewsCount: 700,
        bookmarksCount: 0,
        likedBy: [_miracle],
      ),
      const PostModel(
        id: 'post_5',
        author: UserModel(
          id: 'author_felix_rent',
          name: 'Felix Okon',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&fit=crop',
        ),
        category: PostCategory.request,
        tag: PropertyTag.lookingToRent,
        content:
            'Looking for a 2-bedroom apartment in Yaba or Akoka. Must have constant water and parking for one car. Moving in by end of next month.rviced 3-bedroom apartment with fitted kitchen, parking for 3 cars, and 24/7 power. Inspection opens this Saturday.',
        location: 'Lekki Phase 1, Lagos',
        timeAgo: 'Just Now',
        likesCount: 1,
        commentsCount: 0,
        likedBy: [_miracle],
      ),
    ];
  }

  @override
  Future<List<StoryModel>> getStories() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_stories);
  }

  @override
  Future<List<PostModel>> getPosts({String? filter}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (filter == null || filter.isEmpty || filter == 'All') {
      return List.unmodifiable(_posts);
    }
    return _posts.where((p) {
      if (filter == 'Requests') return p.category == PostCategory.request;
      if (filter == 'General') return p.category == PostCategory.general;
      if (filter == 'Properties') return p.category == PostCategory.property;
      return true;
    }).toList();
  }

  @override
  Future<PostModel> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) {
      throw Exception('Post with id $postId not found');
    }
    final post = _posts[index];
    final isLiked = !post.isLiked;
    final updated = post.copyWith(
      isLiked: isLiked,
      likesCount: isLiked ? post.likesCount + 1 : (post.likesCount > 0 ? post.likesCount - 1 : 0),
    );
    _posts[index] = updated;
    return updated;
  }

  @override
  Future<PostModel> toggleBookmark(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) {
      throw Exception('Post with id $postId not found');
    }
    final post = _posts[index];
    final isBookmarked = !post.isBookmarked;
    final updated = post.copyWith(
      isBookmarked: isBookmarked,
      bookmarksCount: isBookmarked ? post.bookmarksCount + 1 : (post.bookmarksCount > 0 ? post.bookmarksCount - 1 : 0),
    );
    _posts[index] = updated;
    return updated;
  }

  @override
  Future<PostModel> createPost({
    required String content,
    required PostCategory category,
    PropertyTag? tag,
    String? location,
    String? mediaUrl,
  }) async {
    final newPost = PostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      author: _currentUser,
      category: category,
      tag: tag,
      content: content,
      location: location ?? 'Lekki Phase 1, Lagos',
      timeAgo: 'Just Now',
      mediaUrl: mediaUrl,
    );
    _posts.insert(0, newPost);
    return newPost;
  }
}
