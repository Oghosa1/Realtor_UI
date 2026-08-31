import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../features/feed/views/feed_screen.dart';
import '../features/listing/views/create_listing_screen.dart';
import '../features/notifications/views/notifications_screen.dart';
import '../features/profile/views/profile_screen.dart';
import '../features/search/views/search_screen.dart';
import '../shared/widgets/custom_bottom_nav.dart';
import 'constants.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Centralized GoRouter navigation configuration using StatefulShellRoute to ensure
/// the bottom navbar stays permanently static and never slides on screen changes.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.feed,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: navigationShell,
          bottomNavigationBar: CustomBottomNav(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.feed,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FeedScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SearchScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.createListing,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CreateListingScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.notifications,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: NotificationsScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
