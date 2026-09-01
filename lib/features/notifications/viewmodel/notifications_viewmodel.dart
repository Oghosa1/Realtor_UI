import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsState {
  const NotificationsState({
    this.unreadCount = 0,
    this.notifications = const [],
  });

  final int unreadCount;
  final List<String> notifications; // Replace with proper model later

  NotificationsState copyWith({
    int? unreadCount,
    List<String>? notifications,
  }) {
    return NotificationsState(
      unreadCount: unreadCount ?? this.unreadCount,
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationsNotifier extends AutoDisposeNotifier<NotificationsState> {
  @override
  NotificationsState build() => const NotificationsState();

  void markAsRead() {
    state = state.copyWith(unreadCount: 0);
  }
}

final notificationsProvider = AutoDisposeNotifierProvider<NotificationsNotifier, NotificationsState>(NotificationsNotifier.new);
