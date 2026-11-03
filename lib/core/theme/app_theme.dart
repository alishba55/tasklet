import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.cardBg,
          onSurface: AppColors.textDark,
          primary: AppColors.primary,
          onPrimary: AppColors.white,
        ),
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textDark),
          titleTextStyle: TextStyle(
            color: AppColors.textDark,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, AppDimens.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusButton),
            ),
            textStyle: const TextStyle(
              fontSize: AppDimens.fontButton,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            elevation: 0,
          ),
        ),
        // ── Global TextField / InputDecoration — NO border at all ──────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusInput),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusInput),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusInput),
            borderSide: BorderSide.none,   // <-- blue border hataya
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusInput),
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusInput),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingL,
            vertical: AppDimens.paddingM,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.cardBg,
          selectedItemColor: AppColors.navActive,
          unselectedItemColor: AppColors.navInactive,
          selectedLabelStyle: TextStyle(
            fontSize: AppDimens.fontNav,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: AppDimens.fontNav,
            fontWeight: FontWeight.w400,
          ),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: AppDimens.fontDisplay,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: AppDimens.fontCardTitle,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: -0.2,
          ),
          bodySmall: TextStyle(
            fontSize: AppDimens.fontCardDesc,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrey,
            height: 1.4,
          ),
          labelSmall: TextStyle(
            fontSize: AppDimens.fontSectionLabel,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
            letterSpacing: AppDimens.letterSpacingSection,
          ),
        ),
      );
}
