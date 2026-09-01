import 'dart:async';
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
    this.currentPage = 1,
    this.hasMorePosts = true,
    this.isLoadingMore = false,
  });

  final List<StoryModel> stories;
  final List<PostModel> posts;
  final String selectedFilter;
  final int currentPage;
  final bool hasMorePosts;
  final bool isLoadingMore;

  FeedState copyWith({
    List<StoryModel>? stories,
    List<PostModel>? posts,
    String? selectedFilter,
    int? currentPage,
    bool? hasMorePosts,
    bool? isLoadingMore,
  }) {
    return FeedState(
      stories: stories ?? this.stories,
      posts: posts ?? this.posts,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentPage: currentPage ?? this.currentPage,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Service provider for feed operations, utilizing FeedService for robust network requests.
final feedServiceProvider = Provider<FeedService>((ref) {
  return FeedService();
});

/// Notifier handling feed state, fetching, filtering, and engagement interactions.
class FeedNotifier extends AutoDisposeAsyncNotifier<FeedState> {
  static const int _pageSize = 5;

  @override
  FutureOr<FeedState> build() async {
    final service = ref.watch(feedServiceProvider);
    final stories = await service.getStories();
    final posts = await service.getPosts(limit: _pageSize, page: 1);
    
    return FeedState(
      stories: stories,
      posts: posts,
      selectedFilter: 'All',
      currentPage: 1,
      hasMorePosts: posts.length >= _pageSize,
      isLoadingMore: false,
    );
  }

  /// Sets the active filter and queries posts accordingly.
  Future<void> setFilter(String filter) async {
    final current = state.value;
    if (current == null) return;

    state = const AsyncValue.loading();
    try {
      final service = ref.read(feedServiceProvider);
      final posts = await service.getPosts(
        filter: filter,
        limit: _pageSize,
        page: 1,
      );
      state = AsyncValue.data(
        current.copyWith(
          posts: posts,
          selectedFilter: filter,
          currentPage: 1,
          hasMorePosts: posts.length >= _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Fetches the next page of posts and appends them to the feed.
  Future<void> loadMorePosts() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMorePosts) {
      return;
    }

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final service = ref.read(feedServiceProvider);
      final nextPage = current.currentPage + 1;
      final newPosts = await service.getPosts(
        filter: current.selectedFilter,
        limit: _pageSize,
        page: nextPage,
      );

      state = AsyncValue.data(
        current.copyWith(
          posts: [...current.posts, ...newPosts],
          currentPage: nextPage,
          hasMorePosts: newPosts.length >= _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Revert loading indicator on error
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
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
      final service = ref.read(feedServiceProvider);
      await service.toggleLike(postId);
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
      final service = ref.read(feedServiceProvider);
      await service.toggleBookmark(postId);
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
      final service = ref.read(feedServiceProvider);
      final newPost = await service.createPost(
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
final feedProvider = AutoDisposeAsyncNotifierProvider<FeedNotifier, FeedState>(FeedNotifier.new);
