import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../viewmodel/search_viewmodel.dart';

/// Search screen for properties, users, and requests.
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final searchNotifier = ref.read(searchProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextField(
                onChanged: searchNotifier.updateQuery,
                decoration: InputDecoration(
                  hintText: 'Search properties, locations, agents...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.bodyText),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(888),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_rounded, size: 64, color: AppColors.mutedText),
                    const SizedBox(height: 12),
                    Text(
                      searchState.query.isEmpty 
                          ? 'Search for listings and requests'
                          : 'Searching for "${searchState.query}"...',
                      style: const TextStyle(color: AppColors.mutedText, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
