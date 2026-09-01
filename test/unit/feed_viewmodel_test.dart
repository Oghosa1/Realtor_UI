import 'package:expert_listing/features/feed/viewmodel/feed_viewmodel.dart';
import 'package:expert_listing/shared/models/post_model.dart';
import 'package:expert_listing/shared/services/feed_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_mock_feed_service.dart';

void main() {
  group('FeedNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          feedServiceProvider.overrideWithValue(TestMockFeedService()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state loads stories and posts successfully', () async {
      final state = await container.read(feedProvider.future);

      expect(state, isNotNull);
      expect(state.stories.isNotEmpty, isTrue);
      expect(state.posts.isNotEmpty, isTrue);
      expect(state.selectedFilter, equals('All'));
    });

    test('Filtering updates posts correctly', () async {
      await container.read(feedProvider.future);
      
      await container.read(feedProvider.notifier).setFilter('Requests');
      final requestsState = container.read(feedProvider).value;
      expect(requestsState, isNotNull);
      expect(requestsState!.selectedFilter, equals('Requests'));
      expect(
        requestsState.posts.every((p) => p.category == PostCategory.request),
        isTrue,
      );

      await container.read(feedProvider.notifier).setFilter('Properties');
      final propertiesState = container.read(feedProvider).value;
      expect(propertiesState, isNotNull);
      expect(propertiesState!.selectedFilter, equals('Properties'));
      expect(
        propertiesState.posts.every((p) => p.category == PostCategory.property),
        isTrue,
      );
    });

    test('loadMorePosts requests next page and updates state', () async {
      final initialState = await container.read(feedProvider.future);
      final initialCount = initialState.posts.length;

      await container.read(feedProvider.notifier).loadMorePosts();
      final state = container.read(feedProvider).value!;
      expect(state.posts.length, greaterThanOrEqualTo(initialCount));
      expect(state.isLoadingMore, isFalse);
    });

    test('Toggle like optimistically updates post like status and count', () async {
      final initialState = await container.read(feedProvider.future);
      final initialPost = initialState.posts.first;
      final initialLikes = initialPost.likesCount;
      final initialIsLiked = initialPost.isLiked;

      await container.read(feedProvider.notifier).toggleLike(initialPost.id);
      final updatedPost = container.read(feedProvider).value!.posts.firstWhere((p) => p.id == initialPost.id);

      expect(updatedPost.isLiked, equals(!initialIsLiked));
      expect(updatedPost.likesCount, equals(initialLikes + 1));
    });

    test('Create post adds a new post at the beginning of the feed', () async {
      final initialState = await container.read(feedProvider.future);
      final initialCount = initialState.posts.length;

      await container.read(feedProvider.notifier).createPost(
        content: 'Test automated post creation',
        category: PostCategory.request,
        tag: PropertyTag.lookingToBuy,
      );

      final state = container.read(feedProvider).value!;
      expect(state.posts.length, equals(initialCount + 1));
      expect(state.posts.first.content, equals('Test automated post creation'));
    });
  });
}
