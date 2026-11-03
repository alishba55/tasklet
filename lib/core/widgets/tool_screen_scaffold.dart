import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

/// Scaffold for individual tool screens — matches the Stitch detail header:
/// ← [Back]    Title    [avatar]
/// SUBTITLE LABEL • Precision Engine v2.4
class ToolScreenScaffold extends StatelessWidget {
  const ToolScreenScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.categoryColor = AppColors.primary,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingScreen,
                vertical: AppDimens.paddingM,
              ),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusButton),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Title centre
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // Placeholder to keep title centred
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // ── Subtitle badge (e.g. "BODY MASS INDEX UTILITY") ────────────
            if (subtitle != null) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.paddingScreen,
                  right: AppDimens.paddingScreen,
                  bottom: AppDimens.spaceS,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subtitle!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              // Precision engine badge
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: AppDimens.spaceL),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.chipInactive,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Precision Engine v2.4',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // ── Scrollable content ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppDimens.paddingScreen,
                  0,
                  AppDimens.paddingScreen,
                  // Extra bottom padding: nav bar (64) + device safe area + buffer
                  AppDimens.bottomNavHeight + bottomPadding + AppDimens.spaceXL,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
