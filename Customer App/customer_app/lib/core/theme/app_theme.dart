import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// NEARA Design System - Typography & Theme v1.0
/// Implements light theme with Inter font family and design tokens

class AppTextStyles {
  AppTextStyles._();

  // ── Display Styles ────────────────────────────────────────
  /// Large headings for hero sections and main titles
  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle get displaySmall => GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
        height: 1.4,
      );

  // ── Headline Styles ───────────────────────────────────────
  /// Section titles and component headings
  static TextStyle get headlineLarge => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get headlineMedium => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get headlineSmall => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  // ── Body Text Styles ──────────────────────────────────────
  /// Main content and reading text
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  // ── Button Styles ─────────────────────────────────────────
  /// Action buttons and interactive elements
  static TextStyle get buttonLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.0,
      );

  static TextStyle get buttonMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
        height: 1.0,
      );

  static TextStyle get buttonSmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
        height: 1.0,
      );

  // ── Label & Caption Styles ────────────────────────────────
  /// Form labels, metadata, and helper text
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
      );

  // ── Monospace Styles ──────────────────────────────────────
  /// Numbers, codes, and data display
  static TextStyle get monoLarge => GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  static TextStyle get monoMedium => GoogleFonts.jetBrainsMono(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get monoSmall => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  // ── Brand & Special Styles ────────────────────────────────
  /// NEARA-specific styled text elements
  static TextStyle get brandTitle => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.primary,
        letterSpacing: -0.5,
      );

  static TextStyle get voicePrompt => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get emergencyText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );
}

/// NEARA Light Theme Implementation
/// Trust-focused design with accessibility and voice-first interface
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      
      // ── Color Scheme ──────────────────────────────────────
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        onPrimary: Colors.white,
        onPrimaryContainer: AppColors.textPrimary,
        
        secondary: AppColors.info,
        secondaryContainer: AppColors.gray100,
        onSecondary: Colors.white,
        onSecondaryContainer: AppColors.textPrimary,
        
        tertiary: AppColors.success,
        tertiaryContainer: AppColors.gray50,
        onTertiary: Colors.white,
        onTertiaryContainer: AppColors.textPrimary,
        
        error: AppColors.error,
        errorContainer: Color(0xFFFEE2E2),
        onError: Colors.white,
        onErrorContainer: AppColors.error,
        
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        
        surface: AppColors.background,
        surfaceVariant: AppColors.backgroundSecondary,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        
        outline: AppColors.borderDefault,
        outlineVariant: AppColors.gray200,
        
        inversePrimary: AppColors.primaryDark,
        inverseSurface: AppColors.gray800,
        onInverseSurface: AppColors.background,
      ),

      // ── App Bar Theme ─────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
        titleTextStyle: AppTextStyles.headlineMedium,
        shadowColor: AppColors.gray200,
      ),

      // ── Navigation Theme ──────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.primaryLight.withOpacity(0.2),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTextStyles.labelMedium.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.labelMedium.copyWith(color: AppColors.textTertiary);
        }),
      ),

      // ── Button Themes ─────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: AppTextStyles.buttonLarge,
          elevation: 1,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: AppTextStyles.buttonLarge.copyWith(color: AppColors.primary),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),

      // ── Input Field Themes ────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textTertiary),
        labelStyle: AppTextStyles.labelLarge,
        floatingLabelStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borderError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.borderError, width: 2),
        ),
        
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        isDense: false,
      ),

      // ── Card Theme ────────────────────────────────────────
      cardTheme: CardTheme(
        color: AppColors.background,
        elevation: 1,
        shadowColor: AppColors.gray300.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.borderDefault, width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // ── Chip Theme ────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gray100,
        selectedColor: AppColors.primaryLight.withOpacity(0.2),
        disabledColor: AppColors.gray200,
        labelStyle: AppTextStyles.labelMedium,
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
        side: const BorderSide(color: AppColors.borderDefault),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      // ── Dialog Theme ──────────────────────────────────────
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: AppTextStyles.headlineSmall,
        contentTextStyle: AppTextStyles.bodyMedium,
        elevation: 8,
      ),

      // ── Bottom Sheet Theme ────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.background,
        modalBackgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        elevation: 8,
        constraints: BoxConstraints(maxWidth: double.infinity),
      ),

      // ── Floating Action Button Theme ──────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        highlightElevation: 6,
        shape: CircleBorder(),
        sizeConstraints: BoxConstraints.tightFor(width: 56, height: 56),
      ),

      // ── Icon Theme ────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),

      primaryIconTheme: const IconThemeData(
        color: Colors.white,
        size: 24,
      ),

      // ── Divider Theme ─────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDefault,
        thickness: 1,
        space: 1,
      ),

      // ── Slider Theme ──────────────────────────────────────
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.gray200,
        thumbColor: AppColors.primary,
        overlayColor: Color(0x1F2563EB),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
      ),

      // ── Switch Theme ──────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.gray300;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryLight.withOpacity(0.5);
          }
          return AppColors.gray200;
        }),
      ),

      // ── Checkbox Theme ────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: const BorderSide(color: AppColors.borderDefault, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Radio Theme ───────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.gray400;
        }),
      ),

      // ── Material 3 Surface Tints ──────────────────────────
      useMaterial3: true,
    );
  }
}

/// Design System Spacing Constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
  static const double xxxxl = 64.0;
  static const double xxxxxl = 96.0;
}

/// Design System Border Radius Constants
class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double circular = 9999.0;
}

/// Design System Shadow Elevations
class AppShadows {
  static List<BoxShadow> get level1 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          offset: const Offset(0, 1),
          blurRadius: 3,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.24),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ];

  static List<BoxShadow> get level2 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          offset: const Offset(0, 3),
          blurRadius: 6,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.23),
          offset: const Offset(0, 3),
          blurRadius: 6,
        ),
      ];

  static List<BoxShadow> get level3 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.19),
          offset: const Offset(0, 10),
          blurRadius: 20,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.23),
          offset: const Offset(0, 6),
          blurRadius: 6,
        ),
      ];
}
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.saffronAmber,
          side: const BorderSide(color: AppColors.saffronAmber, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.saffronAmber,
          textStyle: GoogleFonts.sora(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.elevatedGraphite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mutedSteel),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.mutedSteel),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.saffronAmber, width: 1.5),
        ),
        hintStyle: GoogleFonts.sora(
          fontSize: 14,
          color: AppColors.mutedFog,
        ),
        labelStyle: GoogleFonts.sora(
          fontSize: 14,
          color: AppColors.softMoonlight,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.warmCharcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.mutedSteel, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.mutedSteel,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.elevatedGraphite,
        selectedColor: AppColors.saffronAmber,
        labelStyle: GoogleFonts.sora(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.softMoonlight,
        ),
        side: const BorderSide(color: AppColors.mutedSteel),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelMedium: AppTextStyles.label,
        labelSmall: AppTextStyles.micro,
      ),
    );
  }
}
