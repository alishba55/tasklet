import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/widgets/tool_screen_scaffold.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Minimal QR-Code encoder (Version 1, ECC-M, byte mode) — no external package
// ─────────────────────────────────────────────────────────────────────────────

class _QrEncoder {
  // Version-1 QR: 21×21 modules, ECC level M (up to 14 bytes usable)
  static const int _size = 21;

  /// Returns a 21×21 bool matrix (true = dark) for [data].
  /// Falls back gracefully for strings that are too long or un-encodable.
  static List<List<bool>>? encode(String data) {
    final bytes = data.codeUnits;
    if (bytes.isEmpty || bytes.length > 14) return null; // v1-M limit
    for (final b in bytes) {
      if (b > 255) return null; // byte mode only
    }

    // ── 1. Build raw bit stream ──────────────────────────────────────────
    final bits = <int>[];
    void addBits(int val, int n) {
      for (int i = n - 1; i >= 0; i--) bits.add((val >> i) & 1);
    }

    addBits(0x4, 4);             // mode indicator: byte
    addBits(bytes.length, 8);    // character count
    for (final b in bytes) addBits(b, 8);
    addBits(0, 4);               // terminator

    // Pad to 128 bits (v1-M data capacity)
    while (bits.length < 128) {
      bits.addAll([1, 1, 1, 0, 1, 1, 0, 0]); // pad codeword 0xEC
      if (bits.length < 128) bits.addAll([0, 0, 0, 1, 0, 0, 0, 1]); // 0x11
    }
    bits.length = 128;

    // Convert to codewords
    final codewords = List<int>.generate(
        16, (i) => bits.sublist(i * 8, i * 8 + 8).fold(0, (a, b) => (a << 1) | b));

    // ── 2. Reed-Solomon ECC (10 bytes for v1-M) ──────────────────────────
    final ec = _rsEncode(codewords, 10);
    final allCW = [...codewords, ...ec];

    // ── 3. Place bits into 21×21 matrix ──────────────────────────────────
    final m = List.generate(_size, (_) => List.filled(_size, false));
    final reserved = List.generate(_size, (_) => List.filled(_size, false));

    void setMod(int r, int c, bool dark) {
      m[r][c] = dark;
      reserved[r][c] = true;
    }

    // Finder patterns
    void finder(int tr, int tc) {
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          final dark = r == 0 || r == 6 || c == 0 || c == 6 ||
              (r >= 2 && r <= 4 && c >= 2 && c <= 4);
          setMod(tr + r, tc + c, dark);
        }
      }
      // Separators
      for (int i = 0; i < 8; i++) {
        if (tr + 7 < _size && tc + i < _size) setMod(tr + 7, tc + i, false);
        if (tr + i < _size && tc + 7 < _size) setMod(tr + i, tc + 7, false);
      }
    }

    finder(0, 0);
    finder(0, 14);
    finder(14, 0);

    // Timing patterns
    for (int i = 8; i < 13; i++) {
      setMod(6, i, i % 2 == 0);
      setMod(i, 6, i % 2 == 0);
    }

    // Dark module
    setMod(13, 8, true);

    // Format info (mask 0, ECC M = 00, mask 000 → format 101010000010010)
    const fmtBits = [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0];
    for (int i = 0; i < 6; i++) setMod(8, i, fmtBits[i] == 1);
    setMod(8, 7, fmtBits[6] == 1);
    setMod(8, 8, fmtBits[7] == 1);
    setMod(7, 8, fmtBits[8] == 1);
    for (int i = 0; i < 6; i++) setMod(5 - i, 8, fmtBits[9 + i] == 1);
    for (int i = 0; i < 8; i++) setMod(20 - i, 8, fmtBits[i] == 1);
    for (int i = 0; i < 7; i++) setMod(8, 14 + i, fmtBits[8 + i] == 1);

    // ── 4. Place data bits (zigzag, mask 0: (r+c)%2==0 inverted) ─────────
    final dataBits = <int>[];
    for (final cw in allCW) {
      for (int i = 7; i >= 0; i--) dataBits.add((cw >> i) & 1);
    }

    int bitIdx = 0;
    bool goUp = true;
    int col = _size - 1;
    while (col >= 0 && bitIdx < dataBits.length) {
      if (col == 6) col--;
      for (int i = 0; i < _size && bitIdx < dataBits.length; i++) {
        final row = goUp ? _size - 1 - i : i;
        for (int dc = 0; dc <= 1; dc++) {
          final c = col - dc;
          if (!reserved[row][c]) {
            int bit = dataBits[bitIdx++];
            // mask 0: invert if (row+c) % 2 == 0
            if ((row + c) % 2 == 0) bit ^= 1;
            m[row][c] = bit == 1;
          }
        }
      }
      goUp = !goUp;
      col -= 2;
    }

    return m;
  }

  // GF(256) Reed-Solomon encoder
  static List<int> _rsEncode(List<int> data, int nec) {
    // Generator polynomial for 10 error correction codewords (v1-M)
    const gen = [251, 67, 46, 61, 118, 70, 64, 94, 32, 45, 1];
    final msg = [...data, ...List.filled(nec, 0)];
    for (int i = 0; i < data.length; i++) {
      final coef = msg[i];
      if (coef != 0) {
        for (int j = 0; j < gen.length; j++) {
          msg[i + j] ^= _gfMul(gen[j], coef);
        }
      }
    }
    return msg.sublist(data.length);
  }

  static final _exp = List<int>.filled(512, 0);
  static final _log = List<int>.filled(256, 0);
  static bool _gfInit = false;

  static void _initGf() {
    if (_gfInit) return;
    int x = 1;
    for (int i = 0; i < 255; i++) {
      _exp[i] = x;
      _log[x] = i;
      x <<= 1;
      if (x & 0x100 != 0) x ^= 0x11d;
    }
    for (int i = 255; i < 512; i++) _exp[i] = _exp[i - 255];
    _gfInit = true;
  }

  static int _gfMul(int a, int b) {
    _initGf();
    if (a == 0 || b == 0) return 0;
    return _exp[(_log[a] + _log[b]) % 255];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CustomPainter that draws the QR matrix
// ─────────────────────────────────────────────────────────────────────────────

class _QrPainter extends CustomPainter {
  final List<List<bool>> matrix;
  _QrPainter(this.matrix);

  @override
  void paint(Canvas canvas, Size size) {
    final n = matrix.length;
    final cell = size.width / n;
    final dark = Paint()..color = Colors.black;
    final light = Paint()..color = Colors.white;

    canvas.drawRect(Offset.zero & size, light);
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if (matrix[r][c]) {
          canvas.drawRect(
            Rect.fromLTWH(c * cell, r * cell, cell, cell),
            dark,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => old.matrix != matrix;
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  final _ctrl = TextEditingController();
  String _data = '';
  String _selectedType = 'Text';
  List<List<bool>>? _matrix;
  String? _errorMsg;

  final _types = ['Text', 'URL', 'Email', 'Phone', 'WiFi'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _buildQrData(String input) {
    if (input.isEmpty) return '';
    switch (_selectedType) {
      case 'URL':
        return input.startsWith('http') ? input : 'https://$input';
      case 'Email':
        return 'mailto:$input';
      case 'Phone':
        return 'tel:$input';
      case 'WiFi':
        final parts = input.split(':');
        if (parts.length >= 2) {
          return 'WIFI:S:${parts[0]};T:WPA;P:${parts[1]};;';
        }
        return input;
      default:
        return input;
    }
  }

  void _onTextChanged(String v) {
    final qrData = _buildQrData(v);
    if (qrData.isEmpty) {
      setState(() { _data = ''; _matrix = null; _errorMsg = null; });
      return;
    }
    final matrix = _QrEncoder.encode(qrData);
    setState(() {
      _data = qrData;
      _matrix = matrix;
      _errorMsg = matrix == null
          ? 'Text too long for QR v1 (max ~14 chars). Shorten it.'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToolScreenScaffold(
      title: 'QR Generator',
      subtitle: 'Create QR Codes Instantly',
      categoryColor: AppColors.metricsLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Type chips ────────────────────────────────────────────────
          const Text('QR TYPE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: AppColors.textGrey, letterSpacing: 1.4)),
          const SizedBox(height: AppDimens.spaceS),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _types.map((t) {
                final sel = t == _selectedType;
                return GestureDetector(
                  onTap: () {
                    setState(() { _selectedType = t; });
                    _ctrl.clear();
                    _onTextChanged('');
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primary : AppColors.chipInactive,
                      borderRadius: BorderRadius.circular(AppDimens.radiusChip),
                    ),
                    child: Text(t,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: sel ? AppColors.white : AppColors.textDark)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),

          // ── Input ─────────────────────────────────────────────────────
          Text(
            _selectedType == 'WiFi' ? 'ENTER SSID:PASSWORD'
                : 'ENTER ${_selectedType.toUpperCase()}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                color: AppColors.textGrey, letterSpacing: 1.4),
          ),
          const SizedBox(height: AppDimens.spaceS),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              boxShadow: const [BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: AppDimens.shadowBlurRadius,
                  offset: Offset(0, AppDimens.shadowOffset))],
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingL, vertical: 4),
            child: TextField(
              controller: _ctrl,
              cursorColor: AppColors.primary,
              style: const TextStyle(fontSize: 15, color: AppColors.textDark,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: _selectedType == 'WiFi' ? 'MyNetwork:pass123'
                    : _selectedType == 'URL' ? 'example.com'
                    : _selectedType == 'Email' ? 'you@email.com'
                    : _selectedType == 'Phone' ? '+92 300 0000000'
                    : 'Enter text (max ~14 chars)…',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
              onChanged: _onTextChanged,
            ),
          ),

          if (_errorMsg != null) ...[
            const SizedBox(height: AppDimens.spaceS),
            Text(_errorMsg!,
                style: const TextStyle(fontSize: 12, color: Color(0xFFC62828))),
          ],

          const SizedBox(height: AppDimens.spaceXL),

          // ── QR Display ────────────────────────────────────────────────
          if (_matrix != null) ...[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                boxShadow: const [BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: AppDimens.shadowBlurRadius,
                    offset: Offset(0, AppDimens.shadowOffset))],
              ),
              padding: const EdgeInsets.all(AppDimens.paddingXXL),
              child: Column(
                children: [
                  // Actual QR code drawn with CustomPainter
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: _QrPainter(_matrix!),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceL),
                  Text(_data,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: AppDimens.spaceM),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _data));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 2)));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.chipInactive,
                        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy_rounded, size: 16, color: AppColors.textDark),
                          SizedBox(width: 6),
                          Text('Copy Data',
                              style: TextStyle(fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_data.isEmpty) ...[
            Center(
              child: Column(
                children: const [
                  SizedBox(height: 40),
                  Icon(Icons.qr_code_rounded, size: 60, color: AppColors.textMuted),
                  SizedBox(height: 12),
                  Text('Type something above to generate\nyour QR code',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
