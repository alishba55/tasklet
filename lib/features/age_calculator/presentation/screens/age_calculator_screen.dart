import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/age_provider.dart';

class AgeCalculatorScreen extends ConsumerStatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  ConsumerState<AgeCalculatorScreen> createState() =>
      _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends ConsumerState<AgeCalculatorScreen> {
  DateTime? _selectedDate;
  DateTime _asOfDate = DateTime.now();
  final _fmt = DateFormat('MMMM d, yyyy');
  final _dayFmt = DateFormat('EEEE');

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickAsOfDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _asOfDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _asOfDate = picked);
  }

  void _calculate() {
    if (_selectedDate != null) {
      ref
          .read(ageNotifierProvider.notifier)
          .calculate(_selectedDate!, asOf: _asOfDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(ageNotifierProvider);
    final totalDaysLived = _selectedDate != null
        ? _asOfDate.difference(_selectedDate!).inDays
        : null;

    return ToolScreenScaffold(
      title: AppStrings.toolAge,
      subtitle: 'Chronology Utility',
      categoryColor: AppColors.chronologyLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Date of birth card ──────────────────────────────────────────
          const Text(
            'DATE OF BIRTH',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: AppDimens.spaceS),
          GestureDetector(
            onTap: _pickBirthDate,
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
              padding: const EdgeInsets.all(AppDimens.paddingL),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedDate != null
                              ? _fmt.format(_selectedDate!)
                              : 'Select your birthdate',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _selectedDate != null
                                ? AppColors.textDark
                                : AppColors.textMuted,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (_selectedDate != null && totalDaysLived != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${_dayFmt.format(_selectedDate!)} • $totalDaysLived days lived',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),

          // ── As of date row ────────────────────────────────────────────
          GestureDetector(
            onTap: _pickAsOfDate,
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
                  horizontal: AppDimens.paddingL, vertical: AppDimens.paddingM),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: AppDimens.spaceM),
                  const Text(
                    'CALCULATION AS OF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _fmt.format(_asOfDate),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // ── Calculate button ──────────────────────────────────────────
          PrimaryButton(
            label: '  Calculate Chronology',
            icon: Icons.bolt_rounded,
            onPressed: _selectedDate != null ? _calculate : null,
          ),

          // ── Results ───────────────────────────────────────────────────
          if (result != null) ...[
            const SizedBox(height: AppDimens.spaceXL),

            // Exact age breakdown
            _SectionLabel(label: 'EXACT AGE BREAKDOWN', badge: 'Precise'),
            const SizedBox(height: AppDimens.spaceM),
            Row(
              children: [
                Expanded(
                    child: _AgeBox(value: '${result.years}', label: 'YEARS')),
                const SizedBox(width: AppDimens.spaceM),
                Expanded(
                    child: _AgeBox(value: '${result.months}', label: 'MONTHS')),
                const SizedBox(width: AppDimens.spaceM),
                Expanded(
                    child: _AgeBox(value: '${result.days}', label: 'DAYS')),
              ],
            ),
            const SizedBox(height: AppDimens.spaceM),

            // Next birthday
            _NextBirthday(birthDate: _selectedDate!, asOf: _asOfDate),
            const SizedBox(height: AppDimens.spaceXL),

            // Lifetime statistics
            const _SectionLabel(label: 'LIFETIME STATISTICS', badge: 'Astronomical Metric'),
            const SizedBox(height: AppDimens.spaceM),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: AppDimens.gridCrossAxisSpacing,
              mainAxisSpacing: AppDimens.gridMainAxisSpacing,
              childAspectRatio: 1.5,
              children: [
                _StatBox(
                  label: 'TOTAL MONTHS',
                  value: '${result.years * 12 + result.months}',
                  sub: 'Elapsed full cycles',
                ),
                _StatBox(
                  label: 'TOTAL WEEKS',
                  value: '${(result.totalDays / 7).floor()}',
                  sub: 'Solar revolutions',
                ),
                _StatBox(
                  label: 'TOTAL DAYS',
                  value: '${result.totalDays}',
                  sub: '${(result.totalDays * 24)} hours',
                ),
                _StatBox(
                  label: 'ZODIAC SIGN',
                  value: _zodiac(_selectedDate!),
                  sub: _zodiacSub(_selectedDate!),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceM),

            // Heartbeats row
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
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingM),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 18, color: AppColors.textGrey),
                  const SizedBox(width: AppDimens.spaceM),
                  const Text(
                    'Estimated Heartbeats',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '~${(result.totalDays * 24 * 60 * 70 / 1e6).toStringAsFixed(1)}M',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }

  String _zodiac(DateTime d) {
    final m = d.month;
    final day = d.day;
    if ((m == 3 && day >= 21) || (m == 4 && day <= 19)) return 'Aries ♈';
    if ((m == 4 && day >= 20) || (m == 5 && day <= 20)) return 'Taurus ♉';
    if ((m == 5 && day >= 21) || (m == 6 && day <= 20)) return 'Gemini ♊';
    if ((m == 6 && day >= 21) || (m == 7 && day <= 22)) return 'Cancer ♋';
    if ((m == 7 && day >= 23) || (m == 8 && day <= 22)) return 'Leo ♌';
    if ((m == 8 && day >= 23) || (m == 9 && day <= 22)) return 'Virgo ♍';
    if ((m == 9 && day >= 23) || (m == 10 && day <= 22)) return 'Libra ♎';
    if ((m == 10 && day >= 23) || (m == 11 && day <= 21)) return 'Scorpio ♏';
    if ((m == 11 && day >= 22) || (m == 12 && day <= 21)) return 'Sagittarius ♐';
    if ((m == 12 && day >= 22) || (m == 1 && day <= 19)) return 'Capricorn ♑';
    if ((m == 1 && day >= 20) || (m == 2 && day <= 18)) return 'Aquarius ♒';
    return 'Pisces ♓';
  }

  String _zodiacSub(DateTime d) {
    final m = d.month;
    final day = d.day;
    if ((m == 3 && day >= 21) || (m == 4 && day <= 19)) return 'Fire • Cardinal Sign';
    if ((m == 4 && day >= 20) || (m == 5 && day <= 20)) return 'Earth • Fixed Sign';
    if ((m == 5 && day >= 21) || (m == 6 && day <= 20)) return 'Air • Mutable Sign';
    if ((m == 6 && day >= 21) || (m == 7 && day <= 22)) return 'Water • Cardinal Sign';
    if ((m == 7 && day >= 23) || (m == 8 && day <= 22)) return 'Fire • Fixed Sign';
    if ((m == 8 && day >= 23) || (m == 9 && day <= 22)) return 'Earth • Mutable Sign';
    if ((m == 9 && day >= 23) || (m == 10 && day <= 22)) return 'Air • Cardinal Sign';
    if ((m == 10 && day >= 23) || (m == 11 && day <= 21)) return 'Water • Fixed Sign';
    if ((m == 11 && day >= 22) || (m == 12 && day <= 21)) return 'Fire • Mutable Sign';
    if ((m == 12 && day >= 22) || (m == 1 && day <= 19)) return 'Earth • Cardinal Sign';
    if ((m == 1 && day >= 20) || (m == 2 && day <= 18)) return 'Air • Fixed Sign';
    return 'Water • Mutable Sign';
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.badge});
  final String label;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
            letterSpacing: 1.4,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.chipInactive,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge!,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AgeBox extends StatelessWidget {
  const _AgeBox({required this.value, required this.label});
  final String value;
  final String label;

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
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              letterSpacing: -1,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, required this.sub});
  final String label;
  final String value;
  final String sub;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextBirthday extends StatelessWidget {
  const _NextBirthday({required this.birthDate, required this.asOf});
  final DateTime birthDate;
  final DateTime asOf;

  @override
  Widget build(BuildContext context) {
    final thisYear = DateTime(asOf.year, birthDate.month, birthDate.day);
    final nextBirthday =
        thisYear.isAfter(asOf) ? thisYear : DateTime(asOf.year + 1, birthDate.month, birthDate.day);
    final daysLeft = nextBirthday.difference(asOf).inDays;
    final months = daysLeft ~/ 30;
    final days = daysLeft % 30;
    final dow = DateFormat('EEE').format(nextBirthday);

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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.chronologyIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.celebration_outlined,
                color: AppColors.chronologyLabel, size: 18),
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NEXT BIRTHDAY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'In $months mo, $days days • $dow',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${daysLeft}d left',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
