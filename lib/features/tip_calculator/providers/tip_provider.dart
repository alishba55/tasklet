import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tip_provider.g.dart';

final class TipState {
  const TipState({
    this.bill = 0,
    this.tipPercent = 15,
    this.people = 1,
  });

  final double bill;
  final int tipPercent;
  final int people;

  double get tipAmount => bill * tipPercent / 100;
  double get total => bill + tipAmount;
  double get perPerson => people > 0 ? total / people : total;

  TipState copyWith({double? bill, int? tipPercent, int? people}) => TipState(
        bill: bill ?? this.bill,
        tipPercent: tipPercent ?? this.tipPercent,
        people: people ?? this.people,
      );
}

@riverpod
class TipNotifier extends _$TipNotifier {
  @override
  TipState build() => const TipState();

  void setBill(double value) => state = state.copyWith(bill: value);
  void setTip(int percent) => state = state.copyWith(tipPercent: percent);
  void setPeople(int count) =>
      state = state.copyWith(people: count.clamp(1, 50));
}
