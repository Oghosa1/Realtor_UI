import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  const ProfileState({
    this.username = 'User',
    this.isLoading = false,
  });

  final String username;
  final bool isLoading;

  ProfileState copyWith({
    String? username,
    bool? isLoading,
  }) {
    return ProfileState(
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileNotifier extends AutoDisposeNotifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true);
    // Future profile fetching logic goes here
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false, username: 'John Doe');
  }
}

final profileProvider = AutoDisposeNotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
