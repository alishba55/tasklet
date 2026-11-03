import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';
import '../../providers/password_provider.dart';

class PasswordGeneratorScreen extends ConsumerWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passwordNotifierProvider);
    final notifier = ref.read(passwordNotifierProvider.notifier);

    return ToolScreenScaffold(
      title: AppStrings.toolPassword,
      categoryColor: AppColors.securityLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.spaceL),
          // Length slider
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Length',
                      style: TextStyle(
                        fontSize: AppDimens.fontInputLabel,
                        color: AppColors.textGrey,
                      ),
                    ),
                    Text(
                      '${state.length}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.background,
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withOpacity(0.1),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: state.length.toDouble(),
                    min: 4,
                    max: 64,
                    divisions: 60,
                    onChanged: (v) => notifier.setLength(v.round()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          // Toggles
          _ToggleRow(
            label: 'Uppercase  (A–Z)',
            value: state.useUppercase,
            onChanged: (_) => notifier.toggleUppercase(),
          ),
          const SizedBox(height: AppDimens.spaceM),
          _ToggleRow(
            label: 'Lowercase  (a–z)',
            value: state.useLowercase,
            onChanged: (_) => notifier.toggleLowercase(),
          ),
          const SizedBox(height: AppDimens.spaceM),
          _ToggleRow(
            label: 'Numbers  (0–9)',
            value: state.useNumbers,
            onChanged: (_) => notifier.toggleNumbers(),
          ),
          const SizedBox(height: AppDimens.spaceM),
          _ToggleRow(
            label: 'Symbols  (!@#\$…)',
            value: state.useSymbols,
            onChanged: (_) => notifier.toggleSymbols(),
          ),
          const SizedBox(height: AppDimens.spaceXL),
          PrimaryButton(
            label: AppStrings.generate,
            icon: Icons.lock_outline,
            onPressed: notifier.generate,
          ),
          if (state.password.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceXL),
            _PasswordResult(password: state.password),
          ],
          const SizedBox(height: AppDimens.spaceXXL),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

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
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppDimens.fontCardDesc,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _PasswordResult extends StatelessWidget {
  const _PasswordResult({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.securityIconBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Row(
        children: [
          Expanded(
            child: Text(
              password,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceM),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: password));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.copied)),
              );
            },
            child: const Icon(
              Icons.copy_rounded,
              color: AppColors.securityLabel,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
