import 'package:expert_listing/shared/models/post_model.dart';
import 'package:expert_listing/shared/widgets/tag_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TagBadge renders correct label and style for Looking to Buy', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TagBadge(tag: PropertyTag.lookingToBuy),
        ),
      ),
    );

    expect(find.text('Looking to Buy'), findsOneWidget);
    expect(find.byIcon(Icons.sell_outlined), findsOneWidget);
  });

  testWidgets('TagBadge renders correct label and style for For Rent', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TagBadge(tag: PropertyTag.forRent),
        ),
      ),
    );

    expect(find.text('For Rent'), findsOneWidget);
    expect(find.byIcon(Icons.vpn_key_outlined), findsOneWidget);
  });
}
