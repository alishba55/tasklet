import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/word_provider.dart';

class WordCounterScreen extends ConsumerStatefulWidget {
  const WordCounterScreen({super.key});

  @override
  ConsumerState<WordCounterScreen> createState() => _WordCounterScreenState();
}

class _WordCounterScreenState extends ConsumerState<WordCounterScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(wordNotifierProvider);

    return ToolScreenScaffold(
      title: AppStrings.toolWord,
      categoryColor: AppColors.stringsLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceL),
          // Text area
          Container(
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
            child: TextField(
              controller: _ctrl,
              maxLines: 8,
              onChanged: (v) =>
                  ref.read(wordNotifierProvider.notifier).analyse(v),
              decoration: const InputDecoration(
                hintText: 'Paste or type your text here…',
                hintStyle: TextStyle(
                  color: AppColors.navInactive,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textDark,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          // Stats grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppDimens.gridCrossAxisSpacing,
            mainAxisSpacing: AppDimens.gridMainAxisSpacing,
            childAspectRatio: 1.6,
            children: [
              _StatCard(label: 'Words', value: '${stats.words}', color: AppColors.stringsLabel, bg: AppColors.stringsIconBg),
              _StatCard(label: 'Characters', value: '${stats.characters}', color: AppColors.shoppingLabel, bg: AppColors.shoppingIconBg),
              _StatCard(label: 'No Spaces', value: '${stats.charactersNoSpaces}', color: AppColors.metricsLabel, bg: AppColors.metricsIconBg),
              _StatCard(label: 'Sentences', value: '${stats.sentences}', color: AppColors.financeLabel, bg: AppColors.financeIconBg),
              _StatCard(label: 'Paragraphs', value: '${stats.paragraphs}', color: AppColors.diningLabel, bg: AppColors.diningIconBg),
              _StatCard(label: 'Read time', value: stats.readingTime, color: AppColors.chronologyLabel, bg: AppColors.chronologyIconBg),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
  });

  final String label;
  final String value;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
