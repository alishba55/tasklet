import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_routes.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/bmi/presentation/screens/bmi_screen.dart';
import '../../features/age_calculator/presentation/screens/age_calculator_screen.dart';
import '../../features/tip_calculator/presentation/screens/tip_calculator_screen.dart';
import '../../features/unit_converter/presentation/screens/unit_converter_screen.dart';
import '../../features/password_generator/presentation/screens/password_generator_screen.dart';
import '../../features/discount_calculator/presentation/screens/discount_calculator_screen.dart';
import '../../features/loan_calculator/presentation/screens/loan_calculator_screen.dart';
import '../../features/word_counter/presentation/screens/word_counter_screen.dart';
import '../../features/currency_converter/presentation/screens/currency_converter_screen.dart';
import '../../features/calorie_calculator/presentation/screens/calorie_calculator_screen.dart';
import '../../features/qr_generator/presentation/screens/qr_generator_screen.dart';
import '../../features/case_converter/presentation/screens/case_converter_screen.dart';
import '../widgets/app_shell.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash, // ← splash se start hoga
    debugLogDiagnostics: false,
    routes: [
      // ── Splash ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ── Shell (Home + Favorites bottom nav) ─────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.favorites,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FavoritesScreen(),
            ),
          ),
        ],
      ),

      // ── Tool screens ────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.bmi,      builder: (_, __) => const BmiScreen()),
      GoRoute(path: AppRoutes.age,      builder: (_, __) => const AgeCalculatorScreen()),
      GoRoute(path: AppRoutes.tip,      builder: (_, __) => const TipCalculatorScreen()),
      GoRoute(path: AppRoutes.unit,     builder: (_, __) => const UnitConverterScreen()),
      GoRoute(path: AppRoutes.password, builder: (_, __) => const PasswordGeneratorScreen()),
      GoRoute(path: AppRoutes.discount, builder: (_, __) => const DiscountCalculatorScreen()),
      GoRoute(path: AppRoutes.loan,     builder: (_, __) => const LoanCalculatorScreen()),
      GoRoute(path: AppRoutes.word,     builder: (_, __) => const WordCounterScreen()),
      GoRoute(path: AppRoutes.currency, builder: (_, __) => const CurrencyConverterScreen()),
      GoRoute(path: AppRoutes.calorie,  builder: (_, __) => const CalorieCalculatorScreen()),
      GoRoute(path: AppRoutes.qr,       builder: (_, __) => const QrGeneratorScreen()),
      GoRoute(path: AppRoutes.caseConv, builder: (_, __) => const CaseConverterScreen()),
    ],
  );
}