import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';

/// White card input field with large bold value text and small grey label.
class InputCard extends StatelessWidget {
  const InputCard({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.hint = '',
    this.onChanged,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String hint;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: AppDimens.fontInputLabel,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.navInactive,
                fontSize: AppDimens.fontInputValue,
                fontWeight: FontWeight.w700,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              suffixIcon: suffix != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: suffix,
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(),
            ),
            style: const TextStyle(
              fontSize: AppDimens.fontInputValue,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
