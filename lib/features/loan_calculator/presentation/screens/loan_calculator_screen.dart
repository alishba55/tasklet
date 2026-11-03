import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/input_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/loan_provider.dart';

class LoanCalculatorScreen extends ConsumerStatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  ConsumerState<LoanCalculatorScreen> createState() =>
      _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends ConsumerState<LoanCalculatorScreen> {
  final _principalCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _termCtrl = TextEditingController();

  @override
  void dispose() {
    _principalCtrl.dispose();
    _rateCtrl.dispose();
    _termCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    ref.read(loanNotifierProvider.notifier).calculate(
          principal: double.tryParse(_principalCtrl.text) ?? 0,
          annualRate: double.tryParse(_rateCtrl.text) ?? 0,
          termMonths: int.tryParse(_termCtrl.text) ?? 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(loanNotifierProvider);

    return ToolScreenScaffold(
      title: AppStrings.toolLoan,
      categoryColor: AppColors.financeLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceL),
          InputCard(
            label: 'Loan Amount (\$)',
            hint: '10000',
            controller: _principalCtrl,
          ),
          const SizedBox(height: AppDimens.spaceL),
          InputCard(
            label: 'Annual Interest Rate (%)',
            hint: '5.5',
            controller: _rateCtrl,
          ),
          const SizedBox(height: AppDimens.spaceL),
          InputCard(
            label: 'Term (months)',
            hint: '60',
            controller: _termCtrl,
          ),
          const SizedBox(height: AppDimens.spaceXL),
          PrimaryButton(
            label: AppStrings.calculate,
            icon: Icons.account_balance_outlined,
            onPressed: _calculate,
          ),
          if (result != null) ...[
            const SizedBox(height: AppDimens.spaceXL),
            ResultCard(
              label: 'Monthly Payment',
              value: '\$${result.monthlyPayment.toStringAsFixed(2)}',
              accentColor: AppColors.financeLabel,
              iconBgColor: AppColors.financeIconBg,
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: AppDimens.spaceL),
            Row(
              children: [
                Expanded(
                  child: _MiniResult(
                    label: 'Total Payment',
                    value: '\$${result.totalPayment.toStringAsFixed(0)}',
                  ),
                ),
                const SizedBox(width: AppDimens.spaceL),
                Expanded(
                  child: _MiniResult(
                    label: 'Total Interest',
                    value: '\$${result.totalInterest.toStringAsFixed(0)}',
                    color: AppColors.metricsLabel,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }
}

class _MiniResult extends StatelessWidget {
  const _MiniResult({required this.label, required this.value, this.color = AppColors.textDark});

  final String label;
  final String value;
  final Color color;

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
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: AppDimens.spaceXS),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color)),
        ],
      ),
    );
  }
}
