import 'package:flutter/material.dart';

/// NEARA Design System - Colors v1.0
/// Light theme colors for trustworthy, accessible interface
class AppColors {
  AppColors._();

  // ── Primary Colors ────────────────────────────────────────
  /// Trust & Professional Blue
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);
  
  // ── Secondary Colors ──────────────────────────────────────
  /// Semantic action colors
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFEA580C);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);
  
  // ── Neutral Scale ─────────────────────────────────────────
  /// Grayscale for backgrounds, text, and borders
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
  
  // ── Semantic Surfaces ─────────────────────────────────────
  /// Background colors for different surface levels
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
  static const Color backgroundTertiary = Color(0xFFF3F4F6);
  
  // ── Text Colors ───────────────────────────────────────────
  /// Text hierarchy for readability
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF374151);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);
  
  // ── Border Colors ─────────────────────────────────────────
  /// Border states for inputs and containers
  static const Color borderDefault = Color(0xFFE5E7EB);
  static const Color borderFocus = Color(0xFF2563EB);
  static const Color borderError = Color(0xFFDC2626);
  
  // ── Brand Accents ─────────────────────────────────────────
  /// NEARA-specific brand colors (legacy naming for compatibility)
  static const Color saffronAmber = Color(0xFF2563EB); // Mapped to primary
  static const Color paleSaffron = Color(0xFF3B82F6); // Mapped to primaryLight
  
  // ── Voice & Emergency ─────────────────────────────────────
  /// Special colors for voice interface and emergency features
  static const Color voiceActive = Color(0xFF2563EB);
  static const Color voiceListening = Color(0xFF3B82F6);
  static const Color voiceSuccess = Color(0xFF059669);
  static const Color voiceError = Color(0xFFDC2626);
  
  static const Color emergencyCrimson = Color(0xFFDC2626);
  static const Color emergencyGlow = Color(0x40DC2626);
  
  // ── Status Colors ─────────────────────────────────────────
  /// Service and booking status indicators
  static const Color liveTeal = Color(0xFF0284C7);
  static const Color safeGreen = Color(0xFF059669);
  static const Color warningAmber = Color(0xFFEA580C);
  
  // ── Legacy & Material Design Support ─────────────────────
  /// Compatibility with existing Material Design components
  static const Color surface = background;
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = textPrimary;
  static const Color onBackground = textPrimary;
  static const Color onSurface = textPrimary;
  static const Color onError = Colors.white;
  
  // ── Utility ───────────────────────────────────────────────
  static const Color transparent = Colors.transparent;
}
