import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/input_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/discount_provider.dart';

class DiscountCalculatorScreen extends ConsumerStatefulWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  ConsumerState<DiscountCalculatorScreen> createState() =>
      _DiscountCalculatorScreenState();
}

class _DiscountCalculatorScreenState
    extends ConsumerState<DiscountCalculatorScreen> {
  final _priceCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();

  @override
  void dispose() {
    _priceCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discountNotifierProvider);
    final notifier = ref.read(discountNotifierProvider.notifier);
    final currency = state.currency;

    return ToolScreenScaffold(
      title: AppStrings.toolDiscount,
      categoryColor: AppColors.shoppingLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceL),

          // ── Currency Selector ─────────────────────────────────────────
          GestureDetector(
            onTap: () => _showCurrencyPicker(context, notifier, currency),
            child: Container(
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingL,
                vertical: AppDimens.paddingM,
              ),
              child: Row(
                children: [
                  const Text(
                    'Currency',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${currency.symbol}  ${currency.code}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.expand_more_rounded,
                            size: 18, color: AppColors.textGrey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimens.spaceL),

          InputCard(
            label: 'Original Price (${currency.symbol})',
            hint: '100.00',
            controller: _priceCtrl,
            onChanged: (v) => notifier.setPrice(double.tryParse(v) ?? 0),
          ),
          const SizedBox(height: AppDimens.spaceL),
          InputCard(
            label: 'Discount (%)',
            hint: '20',
            controller: _discountCtrl,
            onChanged: (v) => notifier.setDiscount(double.tryParse(v) ?? 0),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          PrimaryButton(
            label: AppStrings.calculate,
            icon: Icons.local_offer_outlined,
            onPressed: notifier.calculate,
          ),
          if (state.finalPrice != null) ...[
            const SizedBox(height: AppDimens.spaceXL),
            _DiscountResultPanel(
              original: state.originalPrice ?? 0,
              savings: state.savings ?? 0,
              finalPrice: state.finalPrice ?? 0,
              currencySymbol: currency.symbol,
            ),
          ],
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    DiscountNotifier notifier,
    CurrencyOption selected,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, ctrl) => Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Currency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: CurrencyOption.all.length,
                itemBuilder: (_, i) {
                  final cur = CurrencyOption.all[i];
                  final isSelected = cur.code == selected.code;
                  return GestureDetector(
                    onTap: () {
                      notifier.setCurrency(cur);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            cur.symbol,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              cur.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.textDark,
                              ),
                            ),
                          ),
                          Text(
                            cur.code,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.white.withOpacity(0.7)
                                  : AppColors.textGrey,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle_rounded,
                                size: 18, color: AppColors.white),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _DiscountResultPanel extends StatelessWidget {
  const _DiscountResultPanel({
    required this.original,
    required this.savings,
    required this.finalPrice,
    required this.currencySymbol,
  });

  final double original;
  final double savings;
  final double finalPrice;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Line(
          label: 'Original price',
          value: '$currencySymbol${original.toStringAsFixed(2)}',
        ),
        const SizedBox(height: AppDimens.spaceM),
        _Line(
          label: 'You save',
          value: '$currencySymbol${savings.toStringAsFixed(2)}',
          accent: AppColors.healthLabel,
        ),
        const SizedBox(height: AppDimens.spaceM),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          padding: const EdgeInsets.all(AppDimens.paddingXL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Final price',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$currencySymbol${finalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    this.accent = AppColors.textDark,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: AppDimens.fontCardDesc,
                  color: AppColors.textGrey)),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: accent)),
        ],
      ),
    );
  }
}
