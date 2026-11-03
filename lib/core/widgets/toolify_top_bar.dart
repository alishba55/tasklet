import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

/// Top bar matching the Stitch design:
/// [⚡ logo] TOOLIFY / Home  ────  [avatar circle]
class ToolifyTopBar extends StatelessWidget implements PreferredSizeWidget {
  const ToolifyTopBar({super.key, this.subtitle = 'Home'});

  final String subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      height: preferredSize.height + top,
      padding: EdgeInsets.only(
        top: top,
        left: AppDimens.paddingScreen,
        right: AppDimens.paddingScreen,
      ),
      color: AppColors.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Lightning bolt logo icon ────────────────────────────────────
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          // ── Brand label ─────────────────────────────────────────────────
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOOLIFY',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                  letterSpacing: 1.6,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -0.3,
                  height: 1.1,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
