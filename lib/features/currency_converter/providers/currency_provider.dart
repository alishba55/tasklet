import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency_provider.g.dart';

class CurrencyState {
  final double? result;
  final String fromCurrency;
  final String toCurrency;

  const CurrencyState({
    this.result,
    required this.fromCurrency,
    required this.toCurrency,
  });

  CurrencyState copyWith({
    double? result,
    String? fromCurrency,
    String? toCurrency,
    bool clearResult = false,
  }) =>
      CurrencyState(
        result: clearResult ? null : result ?? this.result,
        fromCurrency: fromCurrency ?? this.fromCurrency,
        toCurrency: toCurrency ?? this.toCurrency,
      );
}

@riverpod
class CurrencyNotifier extends _$CurrencyNotifier {
  // Static exchange rates relative to USD (offline, approximate)
  static const Map<String, double> _toUsd = {
    'USD': 1.0,
    'PKR': 0.00360,
    'EUR': 1.086,
    'GBP': 1.272,
    'INR': 0.01196,
    'AED': 0.2723,
    'SAR': 0.2666,
    'CNY': 0.1379,
    'JPY': 0.00665,
    'CAD': 0.7342,
    'AUD': 0.6512,
    'TRY': 0.0307,
  };

  @override
  CurrencyState build() => const CurrencyState(
        fromCurrency: 'USD',
        toCurrency: 'PKR',
      );

  void convert(double amount) {
    final fromRate = _toUsd[state.fromCurrency] ?? 1.0;
    final toRate = _toUsd[state.toCurrency] ?? 1.0;
    final inUsd = amount * fromRate;
    final result = inUsd / toRate;
    state = state.copyWith(result: result);
  }

  void setFrom(String currency) =>
      state = state.copyWith(fromCurrency: currency, clearResult: true);

  void setTo(String currency) =>
      state = state.copyWith(toCurrency: currency, clearResult: true);

  void swap() {
    state = CurrencyState(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
    );
  }

  static const List<String> currencies = [
    'USD', 'PKR', 'EUR', 'GBP', 'INR',
    'AED', 'SAR', 'CNY', 'JPY', 'CAD', 'AUD', 'TRY',
  ];
}
