import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_tools.dart';
import '../../../../core/models/tool_item.dart';
import '../../../../core/widgets/tool_card.dart';
import '../../../../core/widgets/toolify_top_bar.dart';

// Search query provider
final _searchProvider = StateProvider<String>((ref) => '');

// Filter provider
final _filterProvider = StateProvider<ToolCategory?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(_filterProvider);
    final searchQuery = ref.watch(_searchProvider);
    final allTools = AppTools.all;

    // Apply category filter first, then search filter
    final filtered = allTools.where((t) {
      final matchesCategory =
          selectedCategory == null || t.category == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── Top bar ──────────────────────────────────────────────────
            const SliverToBoxAdapter(child: ToolifyTopBar()),

            // ── Hero header ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.paddingScreen,
                  AppDimens.spaceL,
                  AppDimens.paddingScreen,
                  0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EVERYDAY UTILITIES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceXS),
                          const Text(
                            'Smart Tools',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search icon button — opens search bar
                    GestureDetector(
                      onTap: () => _showSearchBottomSheet(context, ref),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusButton),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              blurRadius: 12,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textDark,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Search bar (shown when query is active) ───────────────────
            if (searchQuery.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.paddingScreen,
                    AppDimens.spaceL,
                    AppDimens.paddingScreen,
                    0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusCard),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 12,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded,
                            size: 18, color: AppColors.textGrey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Searching: "$searchQuery"',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              ref.read(_searchProvider.notifier).state = '',
                          child: const Icon(Icons.close_rounded,
                              size: 18, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Daily Assistant banner ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.paddingScreen,
                  AppDimens.spaceXL,
                  AppDimens.paddingScreen,
                  0,
                ),
                child: GestureDetector(
                  onTap: () => _showDailyAssistant(context),
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
                        // Sparkle icon
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
                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Daily Assistant',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.chipInactive,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'v2.4',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Tap to see quick tips & shortcuts',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Ready badge
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Ready',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Filter chips ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.paddingScreen,
                  AppDimens.spaceXL,
                  0,
                  0,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // "All" chip
                      _FilterChip(
                        label: 'All',
                        isSelected: selectedCategory == null,
                        onTap: () {
                          ref.read(_filterProvider.notifier).state = null;
                          ref.read(_searchProvider.notifier).state = '';
                        },
                      ),
                      const SizedBox(width: AppDimens.spaceS),
                      // Category chips
                      ...ToolCategory.values.map((cat) => Padding(
                            padding: const EdgeInsets.only(
                                right: AppDimens.spaceS),
                            child: _FilterChip(
                              label: cat.label,
                              isSelected: selectedCategory == cat,
                              onTap: () => ref
                                  .read(_filterProvider.notifier)
                                  .state = cat,
                            ),
                          )),
                      const SizedBox(width: AppDimens.paddingScreen),
                    ],
                  ),
                ),
              ),
            ),

            // ── Tool grid ─────────────────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.paddingScreen,
                AppDimens.spaceL,
                AppDimens.paddingScreen,
                AppDimens.paddingScreen +
                    MediaQuery.of(context).padding.bottom +
                    AppDimens.bottomNavHeight,
              ),
              sliver: filtered.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              const Icon(Icons.search_off_rounded,
                                  size: 40, color: AppColors.textGrey),
                              const SizedBox(height: 12),
                              Text(
                                searchQuery.isNotEmpty
                                    ? 'No tools found for "$searchQuery"'
                                    : 'No tools in this category',
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverGrid(
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
          ],
        ),
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
        text: ref.read(_searchProvider));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search Tools',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                cursorColor: AppColors.primary,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. BMI, Password, Discount…',
                  hintStyle: const TextStyle(
                      color: AppColors.textGrey, fontSize: 15),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.textGrey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textGrey),
                    onPressed: () {
                      controller.clear();
                      ref.read(_searchProvider.notifier).state = '';
                      Navigator.pop(ctx);
                    },
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                onChanged: (v) =>
                    ref.read(_searchProvider.notifier).state = v,
                onSubmitted: (v) {
                  ref.read(_searchProvider.notifier).state = v;
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showDailyAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollCtrl) => SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded,
                        color: AppColors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Assistant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '8 offline-ready micro utilities',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'QUICK TIPS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              _AssistantTip(
                icon: Icons.calculate_rounded,
                color: AppColors.financeLabel,
                title: 'Discount Calculator',
                tip:
                    'Enter original price and discount % to instantly see how much you save.',
              ),
              _AssistantTip(
                icon: Icons.lock_outline_rounded,
                color: AppColors.securityLabel,
                title: 'Password Generator',
                tip:
                    'Use at least 16 characters with symbols for strong passwords.',
              ),
              _AssistantTip(
                icon: Icons.monitor_weight_outlined,
                color: AppColors.healthLabel,
                title: 'BMI Calculator',
                tip:
                    'A BMI between 18.5–24.9 is considered a healthy weight range.',
              ),
              _AssistantTip(
                icon: Icons.percent_rounded,
                color: AppColors.shoppingLabel,
                title: 'Tip Calculator',
                tip:
                    'Standard tip is 15–20%. Use the split feature for group bills.',
              ),
              _AssistantTip(
                icon: Icons.swap_horiz_rounded,
                color: AppColors.chronologyLabel,
                title: 'Unit Converter',
                tip:
                    'Supports length, weight, temperature, speed and more — all offline.',
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssistantTip extends StatelessWidget {
  const _AssistantTip({
    required this.icon,
    required this.color,
    required this.title,
    required this.tip,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.chipInactive,
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
