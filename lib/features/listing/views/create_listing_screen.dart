import 'package:flutter/material.dart';
import '../../../core/theme.dart';

/// Screen for creating a new property listing.
class CreateListingScreen extends StatelessWidget {
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_business_rounded, size: 64, color: AppColors.primaryGreen),
              SizedBox(height: 12),
              Text(
                'Post a new Property for Sale or Rent',
                style: TextStyle(color: AppColors.bodyText, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
