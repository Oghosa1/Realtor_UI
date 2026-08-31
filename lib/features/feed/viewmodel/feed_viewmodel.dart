import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/post_model.dart';
import '../../../shared/models/story_model.dart';
import '../../../shared/services/feed_service.dart';

/// State representation for the feed screen.
class FeedState {
  const FeedState({
    this.stories = const [],
    this.posts = const [],
    this.selectedFilter = 'All',
  });

  final List<StoryModel> stories;
  final List<PostModel> posts;
  final String selectedFilter;

  FeedState copyWith({
    List<StoryModel>? stories,
    List<PostModel>? posts,
    String? selectedFilter,
  }) {
    return FeedState(
      stories: stories ?? this.stories,
      posts: posts ?? this.posts,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

/// Service provider for feed operations.
final feedServiceProvider = Provider<FeedService>((ref) {
  return MockFeedService();
});

/// ViewModel handling feed state, fetching, filtering, and engagement interactions.
class FeedViewModel extends StateNotifier<AsyncValue<FeedState>> {
  FeedViewModel(this._feedService) : super(const AsyncValue.loading()) {
    loadFeed();
  }

  final FeedService _feedService;

  /// Loads stories and posts from the service.
  Future<void> loadFeed() async {
    state = const AsyncValue.loading();
    try {
      final stories = await _feedService.getStories();
      final posts = await _feedService.getPosts();
      state = AsyncValue.data(
        FeedState(
          stories: stories,
          posts: posts,
          selectedFilter: 'All',
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Sets the active filter and queries posts accordingly.
  Future<void> setFilter(String filter) async {
    final current = state.value;
    if (current == null) return;

    try {
      final posts = await _feedService.getPosts(filter: filter);
      state = AsyncValue.data(
        current.copyWith(
          posts: posts,
          selectedFilter: filter,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Toggles the like state of a post.
  Future<void> toggleLike(String postId) async {
    final current = state.value;
    if (current == null) return;

    // Optimistic UI update
    final updatedPosts = current.posts.map((p) {
      if (p.id == postId) {
        final newIsLiked = !p.isLiked;
        return p.copyWith(
          isLiked: newIsLiked,
          likesCount: newIsLiked ? p.likesCount + 1 : (p.likesCount > 0 ? p.likesCount - 1 : 0),
        );
      }
      return p;
    }).toList();

    state = AsyncValue.data(current.copyWith(posts: updatedPosts));

    try {
      await _feedService.toggleLike(postId);
    } catch (e) {
      // Revert if failed
      state = AsyncValue.data(current);
    }
  }

  /// Toggles the bookmark state of a post.
  Future<void> toggleBookmark(String postId) async {
    final current = state.value;
    if (current == null) return;

    // Optimistic UI update
    final updatedPosts = current.posts.map((p) {
      if (p.id == postId) {
        final newIsBookmarked = !p.isBookmarked;
        return p.copyWith(
          isBookmarked: newIsBookmarked,
          bookmarksCount: newIsBookmarked ? p.bookmarksCount + 1 : (p.bookmarksCount > 0 ? p.bookmarksCount - 1 : 0),
        );
      }
      return p;
    }).toList();

    state = AsyncValue.data(current.copyWith(posts: updatedPosts));

    try {
      await _feedService.toggleBookmark(postId);
    } catch (e) {
      state = AsyncValue.data(current);
    }
  }

  /// Submits a newly created post.
  Future<void> createPost({
    required String content,
    required PostCategory category,
    PropertyTag? tag,
    String? location,
    String? mediaUrl,
  }) async {
    final current = state.value;
    if (current == null) return;

    try {
      final newPost = await _feedService.createPost(
        content: content,
        category: category,
        tag: tag,
        location: location,
        mediaUrl: mediaUrl,
      );
      state = AsyncValue.data(
        current.copyWith(posts: [newPost, ...current.posts]),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Feature-specific provider co-located with ViewModel as per rules.md.
final feedViewModelProvider =
    StateNotifierProvider<FeedViewModel, AsyncValue<FeedState>>((ref) {
  final service = ref.watch(feedServiceProvider);
  return FeedViewModel(service);
});
