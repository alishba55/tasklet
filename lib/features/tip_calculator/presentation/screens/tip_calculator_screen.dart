import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/input_card.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/tip_provider.dart';

class TipCalculatorScreen extends ConsumerStatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  ConsumerState<TipCalculatorScreen> createState() =>
      _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends ConsumerState<TipCalculatorScreen> {
  final _billCtrl = TextEditingController();

  static const _tipOptions = [10, 15, 18, 20, 25];

  @override
  void dispose() {
    _billCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tipNotifierProvider);

    return ToolScreenScaffold(
      title: AppStrings.toolTip,
      categoryColor: AppColors.diningLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceL),
          InputCard(
            label: 'Bill Amount (\$)',
            hint: '50.00',
            controller: _billCtrl,
            onChanged: (v) =>
                ref.read(tipNotifierProvider.notifier).setBill(
                      double.tryParse(v) ?? 0,
                    ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          // Tip selector
          Text(
            'TIP PERCENTAGE',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: AppDimens.spaceM),
          Wrap(
            spacing: AppDimens.spaceS,
            children: _tipOptions.map((pct) {
              final isSelected = state.tipPercent == pct;
              return GestureDetector(
                onTap: () =>
                    ref.read(tipNotifierProvider.notifier).setTip(pct),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingL,
                    vertical: AppDimens.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBg,
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusButton),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '$pct%',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color:
                          isSelected ? AppColors.white : AppColors.textDark,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          // People counter
          _PeopleCounter(
            count: state.people,
            onDecrement: () =>
                ref.read(tipNotifierProvider.notifier).setPeople(
                      state.people - 1,
                    ),
            onIncrement: () =>
                ref.read(tipNotifierProvider.notifier).setPeople(
                      state.people + 1,
                    ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          // Results
          _ResultRow(label: 'Tip amount', value: '\$${state.tipAmount.toStringAsFixed(2)}'),
          const SizedBox(height: AppDimens.spaceM),
          _ResultRow(label: 'Total', value: '\$${state.total.toStringAsFixed(2)}'),
          const SizedBox(height: AppDimens.spaceM),
          _ResultRow(
            label: 'Per person',
            value: '\$${state.perPerson.toStringAsFixed(2)}',
            isHighlighted: true,
          ),
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }
}

class _PeopleCounter extends StatelessWidget {
  const _PeopleCounter({
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Row(
        children: [
          const Text(
            'Number of people',
            style: TextStyle(
              fontSize: AppDimens.fontCardDesc,
              color: AppColors.textGrey,
            ),
          ),
          const Spacer(),
          _CounterButton(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          _CounterButton(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primary : AppColors.cardBg,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppDimens.fontCardDesc,
              color: isHighlighted ? AppColors.white.withOpacity(0.7) : AppColors.textGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isHighlighted ? AppColors.white : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
