import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingState {
  const ListingState({
    this.isSubmitting = false,
  });

  final bool isSubmitting;

  ListingState copyWith({
    bool? isSubmitting,
  }) {
    return ListingState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ListingNotifier extends AutoDisposeNotifier<ListingState> {
  @override
  ListingState build() => const ListingState();

  Future<void> submitListing() async {
    state = state.copyWith(isSubmitting: true);
    // Future submission logic goes here
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isSubmitting: false);
  }
}

final listingProvider = AutoDisposeNotifierProvider<ListingNotifier, ListingState>(ListingNotifier.new);
