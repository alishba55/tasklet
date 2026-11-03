import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ToolCategory {
  health,
  chronology,
  dining,
  metrics,
  shopping,
  finance,
  security,
  strings,
}

extension ToolCategoryX on ToolCategory {
  String get label => switch (this) {
        ToolCategory.health => 'Health',
        ToolCategory.chronology => 'Chronology',
        ToolCategory.dining => 'Dining',
        ToolCategory.metrics => 'Metrics',
        ToolCategory.shopping => 'Shopping',
        ToolCategory.finance => 'Finance',
        ToolCategory.security => 'Security',
        ToolCategory.strings => 'Strings',
      };

  Color get iconBgColor => switch (this) {
        ToolCategory.health => AppColors.healthIconBg,
        ToolCategory.chronology => AppColors.chronologyIconBg,
        ToolCategory.dining => AppColors.diningIconBg,
        ToolCategory.metrics => AppColors.metricsIconBg,
        ToolCategory.shopping => AppColors.shoppingIconBg,
        ToolCategory.finance => AppColors.financeIconBg,
        ToolCategory.security => AppColors.securityIconBg,
        ToolCategory.strings => AppColors.stringsIconBg,
      };

  Color get labelColor => switch (this) {
        ToolCategory.health => AppColors.healthLabel,
        ToolCategory.chronology => AppColors.chronologyLabel,
        ToolCategory.dining => AppColors.diningLabel,
        ToolCategory.metrics => AppColors.metricsLabel,
        ToolCategory.shopping => AppColors.shoppingLabel,
        ToolCategory.finance => AppColors.financeLabel,
        ToolCategory.security => AppColors.securityLabel,
        ToolCategory.strings => AppColors.stringsLabel,
      };
}

/// Immutable data class representing a single tool card.
final class ToolItem {
  const ToolItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.route,
  });

  final String id;
  final String title;
  final String description;
  final ToolCategory category;
  final IconData icon;
  final String route;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ToolItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
