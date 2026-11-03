import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Base palette (Stitch design) ─────────────────────────────────────────
  static const Color background   = Color(0xFFF4F4F6); // off-white page bg
  static const Color primary      = Color(0xFF1A1A2E); // dark navy
  static const Color cardBg       = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textDark     = Color(0xFF1A1A2E);
  static const Color textGrey     = Color(0xFF8A8A9A);
  static const Color textMuted    = Color(0xFFB0B0C0);
  static const Color divider      = Color(0xFFEEEEF2);
  static const Color white        = Color(0xFFFFFFFF);
  static const Color transparent  = Colors.transparent;

  // ── Shadow ────────────────────────────────────────────────────────────────
  static const Color shadowColor  = Color(0x0D000000); // 5% black — very soft

  // ── Chip / filter pill ───────────────────────────────────────────────────
  static const Color chipActive   = primary;            // dark fill
  static const Color chipInactive = Color(0xFFEEEEF2); // light grey

  // ── Category icon backgrounds (pastel — matches Stitch) ──────────────────
  static const Color healthIconBg      = Color(0xFFD6F5E8); // mint
  static const Color chronologyIconBg  = Color(0xFFFFF3CD); // yellow
  static const Color diningIconBg      = Color(0xFFEDE7F6); // lavender
  static const Color metricsIconBg     = Color(0xFFFCE4EC); // pink-red
  static const Color shoppingIconBg    = Color(0xFFE3F2FD); // sky blue
  static const Color financeIconBg     = Color(0xFFE8F5E9); // light green
  static const Color securityIconBg    = Color(0xFFEDE7F6); // purple
  static const Color stringsIconBg     = Color(0xFFFFF8E1); // peach

  // ── Category label / icon tint colors ────────────────────────────────────
  static const Color healthLabel      = Color(0xFF2E7D32);
  static const Color chronologyLabel  = Color(0xFFF57F17);
  static const Color diningLabel      = Color(0xFF6A1B9A);
  static const Color metricsLabel     = Color(0xFFC62828);
  static const Color shoppingLabel    = Color(0xFF1565C0);
  static const Color financeLabel     = Color(0xFF1B5E20);
  static const Color securityLabel    = Color(0xFF4527A0);
  static const Color stringsLabel     = Color(0xFFE65100);

  // ── Bottom nav ───────────────────────────────────────────────────────────
  static const Color navActive   = primary;
  static const Color navInactive = Color(0xFFBDBDBD);

  // ── Status / accent ──────────────────────────────────────────────────────
  static const Color green   = Color(0xFF2E7D32);
  static const Color red     = Color(0xFFC62828);
  static const Color amber   = Color(0xFFF57F17);
}
