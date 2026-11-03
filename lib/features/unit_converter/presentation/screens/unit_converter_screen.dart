import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/input_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/unit_provider.dart';

class UnitConverterScreen extends ConsumerStatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  ConsumerState<UnitConverterScreen> createState() =>
      _UnitConverterScreenState();
}

class _UnitConverterScreenState extends ConsumerState<UnitConverterScreen> {
  final _valueCtrl = TextEditingController();

  @override
  void dispose() {
    _valueCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(unitNotifierProvider);
    final notifier = ref.read(unitNotifierProvider.notifier);

    return ToolScreenScaffold(
      title: AppStrings.toolUnit,
      categoryColor: AppColors.metricsLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceL),
          // Type chips
          Text('CATEGORY', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: AppDimens.spaceM),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: UnitType.values.map((t) {
                final isSelected = state.type == t;
                return Padding(
                  padding: const EdgeInsets.only(right: AppDimens.spaceS),
                  child: GestureDetector(
                    onTap: () => notifier.setType(t),
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
                        t.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          // Unit dropdowns
          Row(
            children: [
              Expanded(
                child: _UnitDropdown(
                  label: 'From',
                  value: state.fromUnit,
                  units: state.type.units,
                  onChanged: notifier.setFromUnit,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
                child: Icon(Icons.swap_horiz_rounded,
                    color: AppColors.textGrey, size: 28),
              ),
              Expanded(
                child: _UnitDropdown(
                  label: 'To',
                  value: state.toUnit,
                  units: state.type.units,
                  onChanged: notifier.setToUnit,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXL),
          InputCard(label: 'Value', hint: '1', controller: _valueCtrl),
          const SizedBox(height: AppDimens.spaceXL),
          PrimaryButton(
            label: AppStrings.convert,
            icon: Icons.straighten_outlined,
            onPressed: () => notifier.convert(
              double.tryParse(_valueCtrl.text) ?? 0,
            ),
          ),
          if (state.result != null) ...[
            const SizedBox(height: AppDimens.spaceXL),
            ResultCard(
              label: '${state.fromUnit} → ${state.toUnit}',
              value: state.result!
                  .toStringAsFixed(state.result! < 0.01 ? 6 : 4),
              accentColor: AppColors.metricsLabel,
              iconBgColor: AppColors.metricsIconBg,
              icon: Icons.straighten_outlined,
            ),
          ],
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  const _UnitDropdown({
    required this.label,
    required this.value,
    required this.units,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> units;
  final ValueChanged<String> onChanged;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            items: units
                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                .toList(),
            onChanged: (v) => v != null ? onChanged(v) : null,
          ),
        ],
      ),
    );
  }
}
