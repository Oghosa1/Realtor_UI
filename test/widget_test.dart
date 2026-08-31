import 'package:expert_listing/main.dart';
import 'package:expert_listing/shared/widgets/custom_bottom_nav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ExpertListingApp smoke test and stationary bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ExpertListingApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ExpertListingApp), findsOneWidget);
    expect(find.byType(CustomBottomNav), findsOneWidget);
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);

    // Switch to Search tab
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomBottomNav), findsOneWidget);

    // Switch to Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomBottomNav), findsOneWidget);
    expect(find.text('Real Estate Enthusiast & Broker'), findsOneWidget);

    // Switch back to Feed tab
    await tester.tap(find.text('Feed'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomBottomNav), findsOneWidget);
    expect(find.text('Your Story'), findsOneWidget);
  });
}
