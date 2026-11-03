import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/bmi_provider.dart';

// Local toggle for metric/imperial
final _isMetricProvider = StateProvider<bool>((ref) => true);

class BmiScreen extends ConsumerStatefulWidget {
  const BmiScreen({super.key});

  @override
  ConsumerState<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends ConsumerState<BmiScreen> {
  int _heightCm = 175;
  int _weightKg = 68;
  // Imperial
  int _heightFt = 5, _heightIn = 9;
  int _weightLb = 150;

  void _calculate() {
    final isMetric = ref.read(_isMetricProvider);
    double hCm = isMetric
        ? _heightCm.toDouble()
        : (_heightFt * 30.48 + _heightIn * 2.54);
    double wKg = isMetric ? _weightKg.toDouble() : _weightLb * 0.453592;
    ref
        .read(bmiNotifierProvider.notifier)
        .calculate(weightKg: wKg, heightCm: hCm);
  }

  @override
  Widget build(BuildContext context) {
    final isMetric = ref.watch(_isMetricProvider);
    final state = ref.watch(bmiNotifierProvider);

    return ToolScreenScaffold(
      title: AppStrings.toolBmi,
      subtitle: 'Body Mass Index Utility',
      categoryColor: AppColors.healthLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Metric / Imperial toggle ────────────────────────────────────
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
                    label: 'Metric (cm / kg)',
                    isActive: isMetric,
                    onTap: () => ref
                        .read(_isMetricProvider.notifier)
                        .state = true,
                  ),
                ),
                Expanded(
                  child: _ToggleTab(
                    label: 'Imperial (in / lbs)',
                    isActive: !isMetric,
                    onTap: () => ref
                        .read(_isMetricProvider.notifier)
                        .state = false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),

          // ── Height stepper ───────────────────────────────────────────────
          _StepperCard(
            icon: Icons.height_rounded,
            label: 'HEIGHT',
            value: isMetric ? '$_heightCm' : '$_heightFt\' $_heightIn"',
            unit: isMetric ? 'cm' : 'ft',
            onDecrement: () => setState(() {
              if (isMetric) {
                if (_heightCm > 100) _heightCm--;
              } else {
                if (_heightIn > 0)
                  _heightIn--;
                else if (_heightFt > 1) {
                  _heightFt--;
                  _heightIn = 11;
                }
              }
            }),
            onIncrement: () => setState(() {
              if (isMetric) {
                if (_heightCm < 250) _heightCm++;
              } else {
                if (_heightIn < 11)
                  _heightIn++;
                else {
                  _heightFt++;
                  _heightIn = 0;
                }
              }
            }),
          ),
          const SizedBox(height: AppDimens.spaceL),

          // ── Weight stepper ───────────────────────────────────────────────
          _StepperCard(
            icon: Icons.monitor_weight_outlined,
            label: 'WEIGHT',
            value: isMetric ? '$_weightKg' : '$_weightLb',
            unit: isMetric ? 'kg' : 'lbs',
            onDecrement: () => setState(() {
              if (isMetric) {
                if (_weightKg > 20) _weightKg--;
              } else {
                if (_weightLb > 44) _weightLb--;
              }
            }),
            onIncrement: () => setState(() {
              if (isMetric) {
                if (_weightKg < 300) _weightKg++;
              } else {
                if (_weightLb < 660) _weightLb++;
              }
            }),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // ── Calculate button ─────────────────────────────────────────────
          PrimaryButton(
            label: '  Calculate BMI',
            icon: Icons.calculate_outlined,
            onPressed: _calculate,
          ),

          // ── Result ───────────────────────────────────────────────────────
          if (state.bmi != null) ...[
            const SizedBox(height: AppDimens.spaceXL),
            _BmiResult(state: state),
          ],
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }
}

// ── Stepper card ─────────────────────────────────────────────────────────────
class _StepperCard extends StatelessWidget {
  const _StepperCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.onDecrement,
    required this.onIncrement,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textGrey),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              _SmallBtn(icon: Icons.remove, onTap: onDecrement),
              const SizedBox(width: AppDimens.spaceS),
              _SmallBtn(icon: Icons.add, onTap: onIncrement),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  const _SmallBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, size: 18, color: AppColors.textDark),
      ),
    );
  }
}

// ── Toggle tab ───────────────────────────────────────────────────────────────
class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusButton - 4),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.white : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}

// ── BMI result section ────────────────────────────────────────────────────────
class _BmiResult extends StatelessWidget {
  const _BmiResult({required this.state});
  final BmiState state;

  Color get _catColor => switch (state.category) {
        BmiCategory.underweight => AppColors.shoppingLabel,
        BmiCategory.normal => AppColors.healthLabel,
        BmiCategory.overweight => AppColors.chronologyLabel,
        BmiCategory.obese => AppColors.metricsLabel,
        null => AppColors.primary,
      };

  double get _bmiPosition {
    final bmi = (state.bmi ?? 18.5).clamp(10.0, 40.0);
    return (bmi - 10) / 30;
  }

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
      padding: const EdgeInsets.all(AppDimens.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'YOUR BMI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.share_outlined,
                        size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    const Text(
                      'Share',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceL),

          // BMI value
          Center(
            child: Text(
              state.bmi!.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
                letterSpacing: -2,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),

          // Category badge
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _catColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _catColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${state.category?.label ?? ''} (${_rangeLabel()})',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _catColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // Scale bar
          _BmiScaleBar(position: _bmiPosition),
          const SizedBox(height: AppDimens.spaceS),

          // Scale labels
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('<18.5', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
              Text('18.5–24.9', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
              Text('25–29.9', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
              Text('30+', style: TextStyle(fontSize: 10, color: AppColors.textGrey)),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // Info box
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingM),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard - 4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_outlined, size: 18, color: _catColor),
                const SizedBox(width: AppDimens.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _infoTitle(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _infoBody(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.spaceXL),
          const Divider(color: AppColors.divider),
          const SizedBox(height: AppDimens.spaceL),

          // BMI table
          const Text(
            'STANDARD BMI CLASSIFICATIONS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),
          ..._classifications(state.category),
        ],
      ),
    );
  }

  String _rangeLabel() => switch (state.category) {
        BmiCategory.underweight => '< 18.5',
        BmiCategory.normal => '18.5 – 24.9',
        BmiCategory.overweight => '25.0 – 29.9',
        BmiCategory.obese => '≥ 30.0',
        null => '',
      };

  String _infoTitle() => switch (state.category) {
        BmiCategory.underweight => 'Below Healthy Range',
        BmiCategory.normal => 'Optimal Health Range',
        BmiCategory.overweight => 'Above Healthy Range',
        BmiCategory.obese => 'Health Risk Range',
        null => '',
      };

  String _infoBody() => switch (state.category) {
        BmiCategory.underweight =>
          'Consider consulting a nutritionist to reach a healthy weight.',
        BmiCategory.normal =>
          'Your body mass index sits comfortably in the standard healthy sector. Maintain balance with regular functional training and nutrient-dense hydration.',
        BmiCategory.overweight =>
          'Consider incorporating regular exercise and a balanced diet.',
        BmiCategory.obese =>
          'We recommend consulting a healthcare professional for guidance.',
        null => '',
      };

  List<Widget> _classifications(BmiCategory? active) {
    final rows = [
      ('Underweight', '< 18.5', BmiCategory.underweight),
      ('Normal weight', '18.5 – 24.9', BmiCategory.normal),
      ('Overweight', '25.0 – 29.9', BmiCategory.overweight),
      ('Obesity', '≥ 30.0', BmiCategory.obese),
    ];
    return rows.map((r) {
      final isActive = r.$3 == active;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spaceS),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingM, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radiusTag),
          ),
          child: Row(
            children: [
              if (isActive)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _catColor,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                r.$1,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w400,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              Text(
                r.$2,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w400,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _BmiScaleBar extends StatelessWidget {
  const _BmiScaleBar({required this.position});
  final double position;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          // Segmented bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(height: 8, color: const Color(0xFF90CAF9))),
                Expanded(
                    flex: 3,
                    child: Container(height: 8, color: const Color(0xFFA5D6A7))),
                Expanded(
                    flex: 2,
                    child: Container(height: 8, color: const Color(0xFFFFCC80))),
                Expanded(
                    flex: 3,
                    child: Container(height: 8, color: const Color(0xFFEF9A9A))),
              ],
            ),
          ),
          // Indicator
          Positioned(
            left: (w * position.clamp(0.0, 1.0)) - 6,
            top: -4,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
