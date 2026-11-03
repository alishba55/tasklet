import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/calorie_provider.dart';

final _isMaleProvider = StateProvider<bool>((ref) => true);
final _activityProvider =
    StateProvider<ActivityLevel>((ref) => ActivityLevel.moderate);

class CalorieCalculatorScreen extends ConsumerStatefulWidget {
  const CalorieCalculatorScreen({super.key});

  @override
  ConsumerState<CalorieCalculatorScreen> createState() =>
      _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState
    extends ConsumerState<CalorieCalculatorScreen> {
  int _age = 25;
  int _weightKg = 70;
  int _heightCm = 170;

  void _calculate() {
    ref.read(calorieNotifierProvider.notifier).calculate(
          weightKg: _weightKg.toDouble(),
          heightCm: _heightCm.toDouble(),
          age: _age,
          isMale: ref.read(_isMaleProvider),
          activity: ref.read(_activityProvider),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isMale = ref.watch(_isMaleProvider);
    final activity = ref.watch(_activityProvider);
    final state = ref.watch(calorieNotifierProvider);

    return ToolScreenScaffold(
      title: 'Calorie Calculator',
      subtitle: 'Daily Calorie Needs (TDEE)',
      categoryColor: AppColors.healthLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gender toggle ─────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.chipInactive,
              borderRadius: BorderRadius.circular(AppDimens.radiusButton),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: _ToggleTab(
                    label: '♂ Male',
                    isSelected: isMale,
                    onTap: () =>
                        ref.read(_isMaleProvider.notifier).state = true,
                  ),
                ),
                Expanded(
                  child: _ToggleTab(
                    label: '♀ Female',
                    isSelected: !isMale,
                    onTap: () =>
                        ref.read(_isMaleProvider.notifier).state = false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // ── Sliders ───────────────────────────────────────────────────
          _SliderTile(
            label: 'Age',
            value: _age.toDouble(),
            min: 10,
            max: 90,
            unit: 'yrs',
            onChanged: (v) => setState(() => _age = v.round()),
          ),
          const SizedBox(height: AppDimens.spaceM),
          _SliderTile(
            label: 'Weight',
            value: _weightKg.toDouble(),
            min: 30,
            max: 200,
            unit: 'kg',
            onChanged: (v) => setState(() => _weightKg = v.round()),
          ),
          const SizedBox(height: AppDimens.spaceM),
          _SliderTile(
            label: 'Height',
            value: _heightCm.toDouble(),
            min: 100,
            max: 220,
            unit: 'cm',
            onChanged: (v) => setState(() => _heightCm = v.round()),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // ── Activity level ────────────────────────────────────────────
          const Text(
            'ACTIVITY LEVEL',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
              letterSpacing: 1.4,
            ),
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ActivityLevel>(
                value: activity,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textGrey, size: 20),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                items: ActivityLevel.values
                    .map((a) => DropdownMenuItem(
                          value: a,
                          child: Text(a.label),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) ref.read(_activityProvider.notifier).state = v;
                },
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          PrimaryButton(label: 'Calculate', onPressed: _calculate),
          const SizedBox(height: AppDimens.spaceXL),

          // ── Result cards ──────────────────────────────────────────────
          if (state.tdee != null) ...[
            Row(
              children: [
                Expanded(
                  child: _ResultCard(
                    label: 'BMR',
                    value: '${state.bmr!.round()}',
                    unit: 'kcal/day',
                    sub: 'Base metabolic rate',
                    color: AppColors.healthIconBg,
                    textColor: AppColors.healthLabel,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceM),
                Expanded(
                  child: _ResultCard(
                    label: 'TDEE',
                    value: '${state.tdee!.round()}',
                    unit: 'kcal/day',
                    sub: 'Total daily needs',
                    color: AppColors.financeIconBg,
                    textColor: AppColors.financeLabel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceM),
            // Goal guide
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
              padding: const EdgeInsets.all(AppDimens.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CALORIE GOALS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  _GoalRow(
                      label: 'Weight Loss',
                      value: '${(state.tdee! - 500).round()} kcal'),
                  _GoalRow(
                      label: 'Maintenance',
                      value: '${state.tdee!.round()} kcal'),
                  _GoalRow(
                      label: 'Weight Gain',
                      value: '${(state.tdee! + 500).round()} kcal'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radiusButton - 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.white : AppColors.textGrey,
              ),
            ),
          ),
        ),
      );
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Container(
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
        padding: const EdgeInsets.fromLTRB(
            AppDimens.paddingL, AppDimens.paddingM, AppDimens.paddingL, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                ),
                const Spacer(),
                Text(
                  '${value.round()} $unit',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.chipInactive,
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withOpacity(0.1),
                trackHeight: 3,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.sub,
    required this.color,
    required this.textColor,
  });
  final String label;
  final String value;
  final String unit;
  final String sub;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        ),
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    letterSpacing: 1.2)),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: textColor)),
            Text(unit,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textGrey)),
            const SizedBox(height: 4),
            Text(sub,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
      );
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textGrey)),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
          ],
        ),
      );
}
