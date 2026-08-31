import 'package:expert_listing/features/feed/viewmodel/feed_viewmodel.dart';
import 'package:expert_listing/shared/models/post_model.dart';
import 'package:expert_listing/shared/services/feed_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedViewModel Tests', () {
    late FeedService mockService;
    late FeedViewModel viewModel;

    setUp(() {
      mockService = MockFeedService();
      viewModel = FeedViewModel(mockService);
    });

    test('Initial state loads stories and posts successfully', () async {
      await viewModel.loadFeed();
      final state = viewModel.state.value;

      expect(state, isNotNull);
      expect(state!.stories.isNotEmpty, isTrue);
      expect(state.posts.isNotEmpty, isTrue);
      expect(state.selectedFilter, equals('All'));
    });

    test('Filtering updates posts correctly', () async {
      await viewModel.loadFeed();

      await viewModel.setFilter('Requests');
      final requestsState = viewModel.state.value;
      expect(requestsState, isNotNull);
      expect(requestsState!.selectedFilter, equals('Requests'));
      expect(
        requestsState.posts.every((p) => p.category == PostCategory.request),
        isTrue,
      );

      await viewModel.setFilter('Properties');
      final propertiesState = viewModel.state.value;
      expect(propertiesState, isNotNull);
      expect(propertiesState!.selectedFilter, equals('Properties'));
      expect(
        propertiesState.posts.every((p) => p.category == PostCategory.property),
        isTrue,
      );
    });

    test('Toggle like optimistically updates post like status and count', () async {
      await viewModel.loadFeed();
      final initialPost = viewModel.state.value!.posts.first;
      final initialLikes = initialPost.likesCount;
      final initialIsLiked = initialPost.isLiked;

      await viewModel.toggleLike(initialPost.id);
      final updatedPost = viewModel.state.value!.posts.firstWhere((p) => p.id == initialPost.id);

      expect(updatedPost.isLiked, equals(!initialIsLiked));
      expect(updatedPost.likesCount, equals(initialLikes + 1));
    });

    test('Create post adds a new post at the beginning of the feed', () async {
      await viewModel.loadFeed();
      final initialCount = viewModel.state.value!.posts.length;

      await viewModel.createPost(
        content: 'Test automated post creation',
        category: PostCategory.request,
        tag: PropertyTag.lookingToBuy,
      );

      final state = viewModel.state.value!;
      expect(state.posts.length, equals(initialCount + 1));
      expect(state.posts.first.content, equals('Test automated post creation'));
    });
  });
}
