import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../viewmodel/listing_viewmodel.dart';

/// Screen for creating a new property listing.
class CreateListingScreen extends ConsumerWidget {
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingState = ref.watch(listingProvider);
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Create Listing',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_business_rounded, size: 64, color: AppColors.primaryGreen),
              const SizedBox(height: 12),
              Text(
                listingState.isSubmitting ? 'Creating listing...' : 'Post a new Property for Sale or Rent',
                style: const TextStyle(color: AppColors.bodyText, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
