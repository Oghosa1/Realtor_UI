import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../viewmodel/feed_viewmodel.dart';
import '../widgets/create_post_bar.dart';
import '../widgets/feed_header.dart';
import '../widgets/filter_button.dart';
import '../widgets/post_card.dart';
import '../widgets/stories_carousel.dart';

/// Main Feed screen rendering the stories carousel, filters, post bar, and infinite scroll posts feed.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(feedProvider.notifier).loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedProvider);
    final viewModel = ref.read(feedProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            FeedHeader(
              onMessageTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Messages clicked')),
                );
              },
            ),

            // Scrollable Content
            Expanded(
              child: feedAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Failed to load feed: $error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.darkText),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(feedProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: AppColors.surface,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (feedState) => RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: () => ref.refresh(feedProvider.future),
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // Stories Section
                      SliverToBoxAdapter(
                        child: StoriesCarousel(
                          stories: feedState.stories,
                          onStoryTap: (story) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Viewing story of ${story.user.name}',
                                ),
                              ),
                            );
                          },
                          onAddStoryTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Add to your story'),
                              ),
                            );
                          },
                        ),
                      ),

                      // Filter Button Pill
                      SliverToBoxAdapter(
                        child: Container(
                          color: AppColors.surface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          alignment: Alignment.centerLeft,
                          child: FilterButton(
                            selectedFilter: feedState.selectedFilter,
                            onFilterSelected: (filter) =>
                                viewModel.setFilter(filter),
                          ),
                        ),
                      ),

                      // Post Creation Bar
                      SliverToBoxAdapter(
                        child: CreatePostBar(
                          userAvatarUrl: feedState.stories.isNotEmpty
                              ? feedState.stories.first.user.avatarUrl
                              : '',
                          onSubmitPost:
                              ({required content, required category, tag}) {
                                viewModel.createPost(
                                  content: content,
                                  category: category,
                                  tag: tag,
                                );
                              },
                        ),
                      ),

                      // Subtle divider before post items
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 2,
                          child: ColoredBox(color: AppColors.feedBackground),
                        ),
                      ),

                      // Feed Post Cards list separated by 2px feedBackground
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final post = feedState.posts[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PostCard(
                                post: post,
                                onLikeTap: () => viewModel.toggleLike(post.id),
                                onBookmarkTap: () =>
                                    viewModel.toggleBookmark(post.id),
                                onCommentTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Comments for ${post.author.name}',
                                      ),
                                    ),
                                  );
                                },
                                onShareTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Post link copied to clipboard',
                                      ),
                                    ),
                                  );
                                },
                                onMoreTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('More options'),
                                    ),
                                  );
                                },
                              ),
                              if (index < feedState.posts.length - 1)
                                const SizedBox(
                                  height: 2,
                                  child: ColoredBox(
                                    color: AppColors.feedBackground,
                                  ),
                                ),
                            ],
                          );
                        }, childCount: feedState.posts.length),
                      ),

                      // Bottom loader when fetching next 10 posts
                      if (feedState.isLoadingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                          ),
                        ),

                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
