import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bmi_provider.g.dart';

enum BmiCategory { underweight, normal, overweight, obese }

extension BmiCategoryX on BmiCategory {
  String get label => switch (this) {
        BmiCategory.underweight => 'Underweight',
        BmiCategory.normal => 'Normal weight',
        BmiCategory.overweight => 'Overweight',
        BmiCategory.obese => 'Obese',
      };
}

final class BmiState {
  const BmiState({this.bmi, this.category});
  final double? bmi;
  final BmiCategory? category;
}

@riverpod
class BmiNotifier extends _$BmiNotifier {
  @override
  BmiState build() => const BmiState();

  void calculate({required double weightKg, required double heightCm}) {
    if (heightCm <= 0 || weightKg <= 0) {
      state = const BmiState();
      return;
    }
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);
    final category = switch (bmi) {
      < 18.5 => BmiCategory.underweight,
      < 25 => BmiCategory.normal,
      < 30 => BmiCategory.overweight,
      _ => BmiCategory.obese,
    };
    state = BmiState(bmi: bmi, category: category);
  }

  void reset() => state = const BmiState();
}
