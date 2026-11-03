import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loan_provider.g.dart';

final class LoanResult {
  const LoanResult({
    required this.monthlyPayment,
    required this.totalPayment,
    required this.totalInterest,
  });

  final double monthlyPayment;
  final double totalPayment;
  final double totalInterest;
}

@riverpod
class LoanNotifier extends _$LoanNotifier {
  @override
  LoanResult? build() => null;

  void calculate({
    required double principal,
    required double annualRate,
    required int termMonths,
  }) {
    if (principal <= 0 || annualRate <= 0 || termMonths <= 0) {
      state = null;
      return;
    }
    final r = annualRate / 100 / 12;
    final n = termMonths;
    final monthly =
        principal * r * pow(1 + r, n) / (pow(1 + r, n) - 1);
    final total = monthly * n;
    state = LoanResult(
      monthlyPayment: monthly,
      totalPayment: total,
      totalInterest: total - principal,
    );
  }
}
