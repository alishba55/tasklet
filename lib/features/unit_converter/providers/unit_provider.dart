import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unit_provider.g.dart';

enum UnitType { length, weight, temperature, area, volume }

extension UnitTypeX on UnitType {
  String get label => switch (this) {
        UnitType.length => 'Length',
        UnitType.weight => 'Weight',
        UnitType.temperature => 'Temperature',
        UnitType.area => 'Area',
        UnitType.volume => 'Volume',
      };

  List<String> get units => switch (this) {
        UnitType.length => ['Meter', 'Kilometer', 'Mile', 'Foot', 'Inch', 'Centimeter'],
        UnitType.weight => ['Kilogram', 'Gram', 'Pound', 'Ounce', 'Ton'],
        UnitType.temperature => ['Celsius', 'Fahrenheit', 'Kelvin'],
        UnitType.area => ['Square Meter', 'Square Kilometer', 'Acre', 'Hectare'],
        UnitType.volume => ['Liter', 'Milliliter', 'Gallon', 'Fluid Ounce', 'Cup'],
      };
}

final class UnitState {
  const UnitState({
    this.type = UnitType.length,
    this.fromUnit = 'Meter',
    this.toUnit = 'Kilometer',
    this.inputValue = 0,
    this.result,
  });

  final UnitType type;
  final String fromUnit;
  final String toUnit;
  final double inputValue;
  final double? result;

  UnitState copyWith({
    UnitType? type,
    String? fromUnit,
    String? toUnit,
    double? inputValue,
    double? result,
  }) =>
      UnitState(
        type: type ?? this.type,
        fromUnit: fromUnit ?? this.fromUnit,
        toUnit: toUnit ?? this.toUnit,
        inputValue: inputValue ?? this.inputValue,
        result: result ?? this.result,
      );
}

@riverpod
class UnitNotifier extends _$UnitNotifier {
  @override
  UnitState build() => const UnitState();

  void setType(UnitType type) {
    final units = type.units;
    state = UnitState(
      type: type,
      fromUnit: units.first,
      toUnit: units.length > 1 ? units[1] : units.first,
    );
  }

  void setFromUnit(String unit) =>
      state = state.copyWith(fromUnit: unit, result: null);

  void setToUnit(String unit) =>
      state = state.copyWith(toUnit: unit, result: null);

  void convert(double value) {
    final result = _convert(value, state.fromUnit, state.toUnit, state.type);
    state = state.copyWith(inputValue: value, result: result);
  }

  double _convert(double value, String from, String to, UnitType type) {
    if (from == to) return value;
    // Convert to base unit, then to target
    final base = _toBase(value, from, type);
    return _fromBase(base, to, type);
  }

  double _toBase(double value, String unit, UnitType type) => switch (type) {
        UnitType.length => switch (unit) {
            'Meter' => value,
            'Kilometer' => value * 1000,
            'Mile' => value * 1609.344,
            'Foot' => value * 0.3048,
            'Inch' => value * 0.0254,
            'Centimeter' => value / 100,
            _ => value,
          },
        UnitType.weight => switch (unit) {
            'Kilogram' => value,
            'Gram' => value / 1000,
            'Pound' => value * 0.453592,
            'Ounce' => value * 0.0283495,
            'Ton' => value * 1000,
            _ => value,
          },
        UnitType.temperature => switch (unit) {
            'Celsius' => value,
            'Fahrenheit' => (value - 32) * 5 / 9,
            'Kelvin' => value - 273.15,
            _ => value,
          },
        UnitType.area => switch (unit) {
            'Square Meter' => value,
            'Square Kilometer' => value * 1e6,
            'Acre' => value * 4046.86,
            'Hectare' => value * 10000,
            _ => value,
          },
        UnitType.volume => switch (unit) {
            'Liter' => value,
            'Milliliter' => value / 1000,
            'Gallon' => value * 3.78541,
            'Fluid Ounce' => value * 0.0295735,
            'Cup' => value * 0.236588,
            _ => value,
          },
      };

  double _fromBase(double base, String unit, UnitType type) => switch (type) {
        UnitType.length => switch (unit) {
            'Meter' => base,
            'Kilometer' => base / 1000,
            'Mile' => base / 1609.344,
            'Foot' => base / 0.3048,
            'Inch' => base / 0.0254,
            'Centimeter' => base * 100,
            _ => base,
          },
        UnitType.weight => switch (unit) {
            'Kilogram' => base,
            'Gram' => base * 1000,
            'Pound' => base / 0.453592,
            'Ounce' => base / 0.0283495,
            'Ton' => base / 1000,
            _ => base,
          },
        UnitType.temperature => switch (unit) {
            'Celsius' => base,
            'Fahrenheit' => base * 9 / 5 + 32,
            'Kelvin' => base + 273.15,
            _ => base,
          },
        UnitType.area => switch (unit) {
            'Square Meter' => base,
            'Square Kilometer' => base / 1e6,
            'Acre' => base / 4046.86,
            'Hectare' => base / 10000,
            _ => base,
          },
        UnitType.volume => switch (unit) {
            'Liter' => base,
            'Milliliter' => base * 1000,
            'Gallon' => base / 3.78541,
            'Fluid Ounce' => base / 0.0295735,
            'Cup' => base / 0.236588,
            _ => base,
          },
      };
}
