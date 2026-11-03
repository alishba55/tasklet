import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calorie_provider.g.dart';

enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive,
}

extension ActivityLevelX on ActivityLevel {
  String get label => switch (this) {
        ActivityLevel.sedentary => 'Sedentary',
        ActivityLevel.light => 'Lightly Active',
        ActivityLevel.moderate => 'Moderately Active',
        ActivityLevel.active => 'Very Active',
        ActivityLevel.veryActive => 'Extra Active',
      };

  double get multiplier => switch (this) {
        ActivityLevel.sedentary => 1.2,
        ActivityLevel.light => 1.375,
        ActivityLevel.moderate => 1.55,
        ActivityLevel.active => 1.725,
        ActivityLevel.veryActive => 1.9,
      };
}

class CalorieState {
  final double? tdee;
  final double? bmr;
  const CalorieState({this.tdee, this.bmr});
}

@riverpod
class CalorieNotifier extends _$CalorieNotifier {
  @override
  CalorieState build() => const CalorieState();

  void calculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
    required ActivityLevel activity,
  }) {
    // Mifflin-St Jeor equation
    final bmr = isMale
        ? 10 * weightKg + 6.25 * heightCm - 5 * age + 5
        : 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    final tdee = bmr * activity.multiplier;
    state = CalorieState(bmr: bmr, tdee: tdee);
  }
}
