import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchState {
  const SearchState({
    this.query = '',
    this.isLoading = false,
  });

  final String query;
  final bool isLoading;

  SearchState copyWith({
    String? query,
    bool? isLoading,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SearchNotifier extends AutoDisposeNotifier<SearchState> {
  @override
  SearchState build() => const SearchState();

  void updateQuery(String newQuery) {
    state = state.copyWith(query: newQuery);
    // Future search logic goes here
  }
}

final searchProvider = AutoDisposeNotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);
