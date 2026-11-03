import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_tools.dart';
import '../../../../core/models/tool_item.dart';
import '../../../../core/widgets/tool_card.dart';
import '../../../../core/widgets/toolify_top_bar.dart';
import '../../providers/favorites_provider.dart';

final _favFilterProvider = StateProvider<ToolCategory?>((ref) => null);

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final selectedCat = ref.watch(_favFilterProvider);
    final favoriteTools = AppTools.all
        .where((t) => favoriteIds.contains(t.id))
        .toList(growable: false);
    final filtered = selectedCat == null
        ? favoriteTools
        : favoriteTools.where((t) => t.category == selectedCat).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Top bar ──────────────────────────────────────────────────
            const SliverToBoxAdapter(
              child: ToolifyTopBar(subtitle: 'Favorites'),
            ),

            // ── Header section ───────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.paddingScreen,
                  AppDimens.spaceL,
                  AppDimens.paddingScreen,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOOLIFY WORKSPACE • Collection',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          'Favorites',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (favoriteTools.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.chipInactive,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${favoriteTools.length} Saved',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        const Spacer(),
                        // Search + sort icons
                        _IconBtn(icon: Icons.search_rounded),
                        const SizedBox(width: 8),
                        _IconBtn(icon: Icons.swap_horiz_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Category filter chips ─────────────────────────────────────
            if (favoriteTools.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.paddingScreen,
                    AppDimens.spaceL,
                    0,
                    0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FavChip(
                          label: 'All (${favoriteTools.length})',
                          isSelected: selectedCat == null,
                          onTap: () => ref
                              .read(_favFilterProvider.notifier)
                              .state = null,
                        ),
                        const SizedBox(width: AppDimens.spaceS),
                        ...ToolCategory.values
                            .where((c) =>
                                favoriteTools.any((t) => t.category == c))
                            .map((cat) => Padding(
                                  padding: const EdgeInsets.only(
                                      right: AppDimens.spaceS),
                                  child: _FavChip(
                                    label: cat.label,
                                    isSelected: selectedCat == cat,
                                    onTap: () => ref
                                        .read(_favFilterProvider.notifier)
                                        .state = cat,
                                  ),
                                )),
                        const SizedBox(width: AppDimens.paddingScreen),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Grid or empty state ───────────────────────────────────────
            if (favoriteTools.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyFavorites(),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppDimens.paddingScreen,
                  AppDimens.spaceL,
                  AppDimens.paddingScreen,
                  AppDimens.paddingScreen +
                      MediaQuery.of(context).padding.bottom +
                      AppDimens.bottomNavHeight,
                ),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppDimens.gridCrossAxisCount,
                    crossAxisSpacing: AppDimens.gridCrossAxisSpacing,
                    mainAxisSpacing: AppDimens.gridMainAxisSpacing,
                    childAspectRatio: AppDimens.gridChildAspectRatio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => ToolCard(tool: filtered[i]),
                    childCount: filtered.length,
                  ),
                ),
              ),

            // ── Smart Quick-Pin banner ────────────────────────────────────
            if (favoriteTools.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.paddingScreen,
                    0,
                    AppDimens.paddingScreen,
                    AppDimens.paddingScreen +
                        MediaQuery.of(context).padding.bottom +
                        AppDimens.bottomNavHeight + 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusCard),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: AppDimens.shadowBlurRadius,
                          offset: Offset(0, AppDimens.shadowOffset),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingL,
                      vertical: AppDimens.paddingM,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.textDark,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceM),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Smart Quick-Pin',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                'Auto-save utilities you access daily',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.chipInactive,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Enable',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusButton),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.textDark, size: 20),
    );
  }
}

class _FavChip extends StatelessWidget {
  const _FavChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary : AppColors.chipInactive,
          borderRadius: BorderRadius.circular(AppDimens.radiusChip),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppDimens.fontChip,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.metricsIconBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 36,
              color: AppColors.metricsLabel,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          const Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimens.spaceS),
          const Text(
            'Tap the ♡ on any tool to save it here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
