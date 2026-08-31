import 'package:flutter/material.dart';
import '../../../core/theme.dart';

/// Search screen for properties, users, and requests.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextField(
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
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_rounded, size: 64, color: AppColors.mutedText),
                    SizedBox(height: 12),
                    Text(
                      'Search for listings and requests',
                      style: TextStyle(color: AppColors.mutedText, fontSize: 16),
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
