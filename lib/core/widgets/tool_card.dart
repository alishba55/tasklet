import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../models/tool_item.dart';
import '../../features/favorites/providers/favorites_provider.dart';

/// Tool card matching the Stitch mockup:
/// icon+heart row → category label → title → description → [label pill] [→]
class ToolCard extends ConsumerWidget {
  const ToolCard({super.key, required this.tool});

  final ToolItem tool;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(tool.id);

    return GestureDetector(
      onTap: () => context.push(tool.route),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: AppDimens.shadowBlurRadius,
              offset: Offset(0, AppDimens.shadowOffset),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon + heart ──────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimens.iconBgSize,
                  height: AppDimens.iconBgSize,
                  decoration: BoxDecoration(
                    color: tool.category.iconBgColor,
                    borderRadius: BorderRadius.circular(AppDimens.radiusIconBg),
                  ),
                  child: Icon(
                    tool.icon,
                    size: AppDimens.iconSize,
                    color: tool.category.labelColor,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () =>
                      ref.read(favoritesProvider.notifier).toggle(tool.id),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 20,
                      color: isFav
                          ? Colors.redAccent
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // ── Title ─────────────────────────────────────────────────────
            Text(
              tool.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppDimens.fontCardTitle,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                height: 1.25,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXS),
            // ── Description ───────────────────────────────────────────────
            Text(
              tool.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppDimens.spaceM),
            // ── Category pill + arrow ─────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tool.category.iconBgColor,
                    borderRadius: BorderRadius.circular(AppDimens.radiusTag),
                  ),
                  child: Text(
                    tool.category.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: tool.category.labelColor,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
