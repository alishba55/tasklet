import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discount_provider.g.dart';

/// Supported currencies with symbol and code
class CurrencyOption {
  const CurrencyOption({required this.code, required this.symbol, required this.name});
  final String code;
  final String symbol;
  final String name;

  static const List<CurrencyOption> all = [
    CurrencyOption(code: 'USD', symbol: '\$', name: 'US Dollar'),
    CurrencyOption(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyOption(code: 'GBP', symbol: '£', name: 'British Pound'),
    CurrencyOption(code: 'PKR', symbol: '₨', name: 'Pakistani Rupee'),
    CurrencyOption(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    CurrencyOption(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
    CurrencyOption(code: 'SAR', symbol: '﷼', name: 'Saudi Riyal'),
    CurrencyOption(code: 'CAD', symbol: 'CA\$', name: 'Canadian Dollar'),
    CurrencyOption(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    CurrencyOption(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    CurrencyOption(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    CurrencyOption(code: 'TRY', symbol: '₺', name: 'Turkish Lira'),
  ];
}

final class DiscountState {
  const DiscountState({
    this.originalPrice,
    this.discountPercent,
    this.result,
    this.currency = const CurrencyOption(code: 'USD', symbol: '\$', name: 'US Dollar'),
  });

  final double? originalPrice;
  final double? discountPercent;
  final _DiscountResult? result;
  final CurrencyOption currency;

  DiscountState copyWith({
    double? originalPrice,
    double? discountPercent,
    _DiscountResult? result,
    CurrencyOption? currency,
  }) =>
      DiscountState(
        originalPrice: originalPrice ?? this.originalPrice,
        discountPercent: discountPercent ?? this.discountPercent,
        result: result ?? this.result,
        currency: currency ?? this.currency,
      );
}

final class _DiscountResult {
  const _DiscountResult({
    required this.savings,
    required this.finalPrice,
  });
  final double savings;
  final double finalPrice;
}

@riverpod
class DiscountNotifier extends _$DiscountNotifier {
  @override
  DiscountState build() => const DiscountState();

  void setPrice(double value) =>
      state = DiscountState(
        originalPrice: value,
        discountPercent: state.discountPercent,
        currency: state.currency,
      );

  void setDiscount(double pct) =>
      state = DiscountState(
        originalPrice: state.originalPrice,
        discountPercent: pct,
        currency: state.currency,
      );

  void setCurrency(CurrencyOption currency) =>
      state = state.copyWith(currency: currency);

  void calculate() {
    final price = state.originalPrice;
    final pct = state.discountPercent;
    if (price == null || pct == null) return;
    final savings = price * pct / 100;
    state = state.copyWith(
      result: _DiscountResult(
        savings: savings,
        finalPrice: price - savings,
      ),
    );
  }
}

// Expose result as a computed value
extension DiscountStateX on DiscountState {
  double? get savings => result?.savings;
  double? get finalPrice => result?.finalPrice;
}
