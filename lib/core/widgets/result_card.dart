import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

/// Displays a computed result with a label, large value, and optional subtitle.
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.accentColor = AppColors.primary,
    this.iconBgColor = const Color(0xFFE8EAF6),
    this.icon,
  });

  final String label;
  final String value;
  final String? subtitle;
  final Color accentColor;
  final Color iconBgColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: AppDimens.shadowBlurRadius,
            offset: Offset(0, AppDimens.shadowOffset),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimens.paddingXXL),
      child: Column(
        children: [
          if (icon != null) ...[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(height: AppDimens.spaceL),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: AppDimens.fontInputLabel,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimens.spaceS),
          Text(
            value,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: accentColor,
              height: 1,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimens.spaceS),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppDimens.fontCardDesc,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
