import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../models/post_model.dart';

/// Tag pill badge matching Figma styles for property types and requests.
class TagBadge extends StatelessWidget {
  const TagBadge({
    super.key,
    required this.tag,
  });

  final PropertyTag tag;

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, foregroundColor) = _getTagStyle(tag);

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(888),
        border: Border.all(
          color: backgroundColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIcon(tag, foregroundColor),
          const SizedBox(width: 4),
          Text(
            tag.label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  height: 1.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(PropertyTag tag, Color foregroundColor) {
    switch (tag) {
      case PropertyTag.lookingToBuy:
        return Image.asset(
          'assets/images/looking_to_buy.png',
          width: 12,
          height: 12,
          color: foregroundColor,
        );
      case PropertyTag.lookingToRent:
        return Icon(Icons.vpn_key_outlined, size: 12, color: foregroundColor);
      case PropertyTag.forRent:
        return Icon(Icons.vpn_key_outlined, size: 12, color: foregroundColor);
      case PropertyTag.forSale:
        return Icon(Icons.sell_outlined, size: 12, color: foregroundColor);
    }
  }

  (Color, Color) _getTagStyle(PropertyTag tag) {
    switch (tag) {
      case PropertyTag.lookingToBuy:
        return (AppColors.tagBuyBackground, AppColors.tagBuyForeground);
      case PropertyTag.lookingToRent:
        return (AppColors.tagRentBackground, AppColors.tagRentForeground);
      case PropertyTag.forRent:
        return (AppColors.tagForRentBackground, AppColors.tagForRentForeground);
      case PropertyTag.forSale:
        return (AppColors.tagForSaleBackground, AppColors.tagForSaleForeground);
    }
  }
}
