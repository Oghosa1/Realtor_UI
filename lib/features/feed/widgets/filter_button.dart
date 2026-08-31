import 'package:flutter/material.dart';
import '../../../core/theme.dart';

/// Filter selection pill button matching Figma specifications.
class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final isFiltered = selectedFilter != 'All';
    final label = isFiltered ? selectedFilter : 'Filters';

    return GestureDetector(
      onTap: () => _showFilterBottomSheet(context),
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isFiltered ? AppColors.inputBackground : AppColors.surface,
          borderRadius: BorderRadius.circular(888),
          border: Border.all(
            color: isFiltered ? AppColors.primaryGreen : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.tune_rounded,
              size: 16,
              color: isFiltered ? AppColors.primaryGreen : AppColors.bodyText,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isFiltered ? AppColors.primaryGreen : AppColors.bodyText,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final options = ['All', 'Requests', 'General', 'Properties'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Feed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                ),
                const SizedBox(height: 16),
                for (final opt in options)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: selectedFilter == opt ? FontWeight.w600 : FontWeight.w400,
                        color: selectedFilter == opt ? AppColors.primaryGreen : AppColors.darkText,
                      ),
                    ),
                    trailing: selectedFilter == opt
                        ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                        : null,
                    onTap: () {
                      Navigator.pop(ctx);
                      onFilterSelected(opt);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
