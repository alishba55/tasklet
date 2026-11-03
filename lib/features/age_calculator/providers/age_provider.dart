import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'age_provider.g.dart';

final class AgeResult {
  const AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalDays,
  });
  final int years;
  final int months;
  final int days;
  final int totalDays;
}

@riverpod
class AgeNotifier extends _$AgeNotifier {
  @override
  AgeResult? build() => null;

  void calculate(DateTime birthDate, {DateTime? asOf}) {
    final now = asOf ?? DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (days < 0) {
      months--;
      final lastMonth = DateTime(now.year, now.month, 0);
      days += lastMonth.day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    final totalDays = now.difference(birthDate).inDays;
    state = AgeResult(
      years: years,
      months: months,
      days: days,
      totalDays: totalDays,
    );
  }
}
