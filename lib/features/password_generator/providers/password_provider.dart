import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_provider.g.dart';

final class PasswordState {
  const PasswordState({
    this.password = '',
    this.length = 16,
    this.useUppercase = true,
    this.useLowercase = true,
    this.useNumbers = true,
    this.useSymbols = true,
  });

  final String password;
  final int length;
  final bool useUppercase;
  final bool useLowercase;
  final bool useNumbers;
  final bool useSymbols;

  PasswordState copyWith({
    String? password,
    int? length,
    bool? useUppercase,
    bool? useLowercase,
    bool? useNumbers,
    bool? useSymbols,
  }) =>
      PasswordState(
        password: password ?? this.password,
        length: length ?? this.length,
        useUppercase: useUppercase ?? this.useUppercase,
        useLowercase: useLowercase ?? this.useLowercase,
        useNumbers: useNumbers ?? this.useNumbers,
        useSymbols: useSymbols ?? this.useSymbols,
      );
}

@riverpod
class PasswordNotifier extends _$PasswordNotifier {
  static const _upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _lower = 'abcdefghijklmnopqrstuvwxyz';
  static const _digits = '0123456789';
  static const _symbols = '!@#\$%^&*()-_=+[]{}|;:,.<>?';

  @override
  PasswordState build() => const PasswordState();

  void setLength(int length) => state = state.copyWith(length: length);
  void toggleUppercase() =>
      state = state.copyWith(useUppercase: !state.useUppercase);
  void toggleLowercase() =>
      state = state.copyWith(useLowercase: !state.useLowercase);
  void toggleNumbers() =>
      state = state.copyWith(useNumbers: !state.useNumbers);
  void toggleSymbols() =>
      state = state.copyWith(useSymbols: !state.useSymbols);

  void generate() {
    final charset = StringBuffer();
    if (state.useUppercase) charset.write(_upper);
    if (state.useLowercase) charset.write(_lower);
    if (state.useNumbers) charset.write(_digits);
    if (state.useSymbols) charset.write(_symbols);
    if (charset.isEmpty) {
      charset.write(_lower);
    }
    final chars = charset.toString();
    final rng = Random.secure();
    final password = List.generate(
      state.length,
      (_) => chars[rng.nextInt(chars.length)],
    ).join();
    state = state.copyWith(password: password);
  }
}
