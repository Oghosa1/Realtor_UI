import 'package:expert_listing/features/feed/views/feed_screen.dart';
import 'package:expert_listing/features/feed/widgets/create_post_bar.dart';
import 'package:expert_listing/features/feed/widgets/feed_header.dart';
import 'package:expert_listing/features/feed/widgets/filter_button.dart';
import 'package:expert_listing/features/feed/widgets/post_card.dart';
import 'package:expert_listing/features/feed/widgets/stories_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FeedScreen renders Header, Stories, Filter button, Post Bar, and Post cards', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: FeedScreen(),
        ),
      ),
    );

    // Settle all async mock timers and animations
    await tester.pumpAndSettle();

    expect(find.byType(FeedHeader), findsOneWidget);
    expect(find.byType(StoriesCarousel), findsOneWidget);
    expect(find.text('Your Story'), findsOneWidget);
    expect(find.byType(FilterButton), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.byType(CreatePostBar), findsOneWidget);
    expect(find.byType(PostCard), findsWidgets);
  });
}
