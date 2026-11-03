import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';

class CaseConverterScreen extends StatefulWidget {
  const CaseConverterScreen({super.key});

  @override
  State<CaseConverterScreen> createState() => _CaseConverterScreenState();
}

class _CaseConverterScreenState extends State<CaseConverterScreen> {
  final _ctrl = TextEditingController();
  String _input = '';

  String get _upper => _input.toUpperCase();
  String get _lower => _input.toLowerCase();
  String get _title => _input
      .split(' ')
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');
  String get _sentence {
    if (_input.isEmpty) return '';
    return _input[0].toUpperCase() + _input.substring(1).toLowerCase();
  }
  String get _camel {
    final words = _input.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    return words[0].toLowerCase() +
        words.sublist(1).map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1).toLowerCase()).join('');
  }
  String get _snake => _input.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  String get _kebab => _input.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied!'), duration: Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasInput = _input.isNotEmpty;

    return ToolScreenScaffold(
      title: 'Case Converter',
      subtitle: 'Text Format Transformer',
      categoryColor: AppColors.stringsLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Input ─────────────────────────────────────────────────────
          const Text(
            'ENTER TEXT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: AppDimens.spaceS),
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
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingL, vertical: 4),
            child: TextField(
              controller: _ctrl,
              maxLines: 4,
              minLines: 3,
              cursorColor: AppColors.primary,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Type or paste your text here…',
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
              onChanged: (v) => setState(() => _input = v),
            ),
          ),
          if (hasInput) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  _ctrl.clear();
                  setState(() => _input = '');
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimens.spaceXL),

          // ── Results ───────────────────────────────────────────────────
          if (hasInput) ...[
            const Text(
              'CONVERTED FORMATS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: AppDimens.spaceS),
            _CaseRow(label: 'UPPERCASE', value: _upper, onCopy: () => _copy(_upper)),
            _CaseRow(label: 'lowercase', value: _lower, onCopy: () => _copy(_lower)),
            _CaseRow(label: 'Title Case', value: _title, onCopy: () => _copy(_title)),
            _CaseRow(label: 'Sentence case', value: _sentence, onCopy: () => _copy(_sentence)),
            _CaseRow(label: 'camelCase', value: _camel, onCopy: () => _copy(_camel)),
            _CaseRow(label: 'snake_case', value: _snake, onCopy: () => _copy(_snake)),
            _CaseRow(label: 'kebab-case', value: _kebab, onCopy: () => _copy(_kebab)),
          ] else
            Center(
              child: Column(
                children: const [
                  SizedBox(height: 40),
                  Icon(Icons.text_format_rounded,
                      size: 60, color: AppColors.textMuted),
                  SizedBox(height: 12),
                  Text(
                    'Enter text above to see all\ncase conversions',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CaseRow extends StatelessWidget {
  const _CaseRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });
  final String label;
  final String value;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: AppDimens.spaceS),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGrey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onCopy,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.copy_rounded,
                    size: 18, color: AppColors.textGrey),
              ),
            ),
          ],
        ),
      );
}
