import 'package:flutter/material.dart';

/// NEARA Design System - Worker Partner App Colors v1.0
/// Professional light theme for service providers
class AppColors {
  AppColors._();

  // ── Primary Colors ────────────────────────────────────────
  /// Professional Trust Blue for Workers
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);
  
  // ── Secondary Colors ──────────────────────────────────────
  /// Status and action colors
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFEA580C);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);
  
  // ── Worker-Specific Colors ────────────────────────────────
  /// Earnings and performance indicators
  static const Color earnings = Color(0xFF059669);
  static const Color pending = Color(0xFFEA580C);
  static const Color available = Color(0xFF0284C7);
  static const Color busy = Color(0xFFDC2626);
  
  // ── Neutral Scale ─────────────────────────────────────────
  /// Clean, professional grayscale
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  
  // ── Background Colors ─────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
  static const Color backgroundTertiary = Color(0xFFF3F4F6);
  
  // ── Text Colors ───────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF374151);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
  
  // ── Border Colors ─────────────────────────────────────────
  static const Color borderDefault = Color(0xFFE5E7EB);
  static const Color borderFocus = Color(0xFF2563EB);
  static const Color borderError = Color(0xFFDC2626);

  // ── Legacy Support (NEARA Branding) ──────────────────────
  /// Mapped to new design system colors for compatibility
  static const Color saffronAmber = Color(0xFF2563EB);
  static const Color paleSaffron = Color(0xFF3B82F6);
  static const Color burntUmber = Color(0xFF1E40AF);
  static const Color saffronGlow = Color(0x402563EB);
  
  static const Color emergencyCrimson = Color(0xFFDC2626);
  static const Color crimsonGlow = Color(0x40DC2626);
  static const Color liveTeal = Color(0xFF0284C7);
  static const Color safeGreen = Color(0xFF059669);
  static const Color warningAmber = Color(0xFFEA580C);
  
  /// Legacy surface colors mapped to light theme
  static const Color midnightNavy = Color(0xFFFFFFFF); // Background
  static const Color warmCharcoal = Color(0xFFF9FAFB); // Background secondary
  static const Color elevatedGraphite = Color(0xFFF3F4F6); // Background tertiary
  static const Color mutedSteel = Color(0xFFE5E7EB); // Border default
  
  /// Legacy text colors mapped to light theme
  static const Color brightIvory = Color(0xFF111827); // Text primary
  static const Color softMoonlight = Color(0xFF374151); // Text secondary
  static const Color mutedFog = Color(0xFF6B7280); // Text tertiary
  
  // ── Material Support ──────────────────────────────────────
  static const Color surface = background;
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = textPrimary;
  static const Color onBackground = textPrimary;
  static const Color onSurface = textPrimary;
  static const Color onError = Colors.white;

  // ── Misc ──────────────────────────────────────────────────
  static const Color transparent = Colors.transparent;
}
