import 'package:flutter/material.dart';
import '../models/tool_item.dart';
import 'app_routes.dart';
import 'app_strings.dart';

/// Master list of every tool in Toolify.
/// Add new tools here; the rest of the UI picks them up automatically.
abstract final class AppTools {
  static const List<ToolItem> all = [
    ToolItem(
      id: 'bmi',
      title: AppStrings.toolBmi,
      description: AppStrings.toolBmiDesc,
      category: ToolCategory.health,
      icon: Icons.monitor_weight_outlined,
      route: AppRoutes.bmi,
    ),
    ToolItem(
      id: 'age',
      title: AppStrings.toolAge,
      description: AppStrings.toolAgeDesc,
      category: ToolCategory.chronology,
      icon: Icons.cake_outlined,
      route: AppRoutes.age,
    ),
    ToolItem(
      id: 'tip',
      title: AppStrings.toolTip,
      description: AppStrings.toolTipDesc,
      category: ToolCategory.dining,
      icon: Icons.restaurant_outlined,
      route: AppRoutes.tip,
    ),
    ToolItem(
      id: 'unit',
      title: AppStrings.toolUnit,
      description: AppStrings.toolUnitDesc,
      category: ToolCategory.metrics,
      icon: Icons.straighten_outlined,
      route: AppRoutes.unit,
    ),
    ToolItem(
      id: 'password',
      title: AppStrings.toolPassword,
      description: AppStrings.toolPasswordDesc,
      category: ToolCategory.security,
      icon: Icons.lock_outline,
      route: AppRoutes.password,
    ),
    ToolItem(
      id: 'discount',
      title: AppStrings.toolDiscount,
      description: AppStrings.toolDiscountDesc,
      category: ToolCategory.shopping,
      icon: Icons.local_offer_outlined,
      route: AppRoutes.discount,
    ),
    ToolItem(
      id: 'loan',
      title: AppStrings.toolLoan,
      description: AppStrings.toolLoanDesc,
      category: ToolCategory.finance,
      icon: Icons.account_balance_outlined,
      route: AppRoutes.loan,
    ),
    ToolItem(
      id: 'word',
      title: AppStrings.toolWord,
      description: AppStrings.toolWordDesc,
      category: ToolCategory.strings,
      icon: Icons.text_fields_outlined,
      route: AppRoutes.word,
    ),
    // ── New tools ─────────────────────────────────────────────────────────
    ToolItem(
      id: 'currency',
      title: AppStrings.toolCurrency,
      description: AppStrings.toolCurrencyDesc,
      category: ToolCategory.finance,
      icon: Icons.currency_exchange_rounded,
      route: AppRoutes.currency,
    ),
    ToolItem(
      id: 'calorie',
      title: AppStrings.toolCalorie,
      description: AppStrings.toolCalorieDesc,
      category: ToolCategory.health,
      icon: Icons.local_fire_department_outlined,
      route: AppRoutes.calorie,
    ),
    ToolItem(
      id: 'qr',
      title: AppStrings.toolQr,
      description: AppStrings.toolQrDesc,
      category: ToolCategory.metrics,
      icon: Icons.qr_code_rounded,
      route: AppRoutes.qr,
    ),
    ToolItem(
      id: 'case',
      title: AppStrings.toolCase,
      description: AppStrings.toolCaseDesc,
      category: ToolCategory.strings,
      icon: Icons.text_format_rounded,
      route: AppRoutes.caseConv,
    ),
  ];
}
