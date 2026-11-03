import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/currency_provider.dart';

class CurrencyConverterScreen extends ConsumerStatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  ConsumerState<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState
    extends ConsumerState<CurrencyConverterScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _convert() {
    final val = double.tryParse(_ctrl.text.trim());
    if (val == null) return;
    ref.read(currencyNotifierProvider.notifier).convert(val);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyNotifierProvider);
    final currencies = CurrencyNotifier.currencies;

    return ToolScreenScaffold(
      title: 'Currency Converter',
      subtitle: 'Offline Exchange Rates',
      categoryColor: AppColors.financeLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Amount input ──────────────────────────────────────────────
          _SectionLabel('Amount'),
          const SizedBox(height: AppDimens.spaceS),
          Container(
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
                horizontal: AppDimens.paddingL, vertical: 4),
            child: TextField(
              controller: _ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              cursorColor: AppColors.primary,
              style: const TextStyle(
                fontSize: AppDimens.fontInputValue,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
              decoration: const InputDecoration(
                hintText: '0.00',
                hintStyle:
                    TextStyle(color: AppColors.textMuted, fontSize: AppDimens.fontInputValue),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // ── Currency pickers ──────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _CurrencyDropdown(
                  label: 'From',
                  value: state.fromCurrency,
                  items: currencies,
                  onChanged: (v) =>
                      ref.read(currencyNotifierProvider.notifier).setFrom(v!),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ref.read(currencyNotifierProvider.notifier).swap(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.swap_horiz_rounded,
                      color: AppColors.white, size: 22),
                ),
              ),
              Expanded(
                child: _CurrencyDropdown(
                  label: 'To',
                  value: state.toCurrency,
                  items: currencies,
                  onChanged: (v) =>
                      ref.read(currencyNotifierProvider.notifier).setTo(v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXL),

          PrimaryButton(label: 'Convert', onPressed: _convert),
          const SizedBox(height: AppDimens.spaceXL),

          // ── Result ────────────────────────────────────────────────────
          if (state.result != null)
            Container(
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
                  const Text(
                    'CONVERTED AMOUNT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  Text(
                    '${state.result!.toStringAsFixed(2)} ${state.toCurrency}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                  Text(
                    '${_ctrl.text} ${state.fromCurrency}  →  ${state.toCurrency}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '* Offline rates — approximate only',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  const _CurrencyDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textGrey, size: 20),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
              items: items
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textGrey,
          letterSpacing: 1.4,
        ),
      );
}
