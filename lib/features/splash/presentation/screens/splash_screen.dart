import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingXXL,
            vertical: AppDimens.paddingXXL + AppDimens.paddingXL,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              _buildCenter(),
              _buildVersion(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenter() {
    return Column(
      children: [
        _buildLogo(),
        const SizedBox(height: AppDimens.spaceXL),
        _buildAppName(),
        const SizedBox(height: AppDimens.spaceL),
        _buildDots(),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.bolt_rounded,
        color: AppColors.white,
        size: 36,
      ),
    );
  }

  Widget _buildAppName() {
    return Column(
      children: [
        Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: AppDimens.fontDisplay,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppDimens.spaceS),
        Text(
          AppStrings.appTagline,
          style: TextStyle(
            fontSize: AppDimens.fontCardDesc,
            fontWeight: FontWeight.w400,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == 0 ? AppColors.primary : AppColors.textMuted,
          ),
        );
      }),
    );
  }

  Widget _buildVersion() {
    return Text(
      AppStrings.appVersion,
      style: TextStyle(
        fontSize: AppDimens.fontSectionLabel,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: AppDimens.letterSpacingSection,
      ),
    );
  }
}