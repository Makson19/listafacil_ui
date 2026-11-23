import 'package:flutter/material.dart';

/// Identidade visual do ListaFácil.
///
/// Centralizar cores, formas e tipografia aqui mantém as telas consistentes
/// e facilita ajustes futuros (inclusive um eventual modo escuro).
abstract final class AppTheme {
  static const Color primaria = Color(0xFF12755F);
  static const Color primariaEscura = Color(0xFF0A5747);
  static const Color destaque = Color(0xFFF4A623);
  static const Color fundo = Color(0xFFF5F8F6);
  static const Color texto = Color(0xFF14211D);
  static const Color textoSecundario = Color(0xFF5F6F69);
  static const Color borda = Color(0xFFE3EAE7);
  static const Color vermelho = Color(0xFFC0392B);

  static const LinearGradient gradientePrimario = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A8A71), Color(0xFF0A5747)],
  );

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: primaria).copyWith(
      primary: primaria,
      onPrimary: Colors.white,
      secondary: destaque,
      surface: Colors.white,
      onSurface: texto,
      error: vermelho,
      outlineVariant: borda,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: fundo,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: texto, displayColor: texto),
      appBarTheme: const AppBarTheme(
        backgroundColor: fundo,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: texto,
          letterSpacing: -0.4,
        ),
        iconTheme: IconThemeData(color: texto),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF6F9F8),
        hintStyle: const TextStyle(color: Color(0xFF9AA8A3)),
        labelStyle: const TextStyle(color: textoSecundario),
        floatingLabelStyle: const TextStyle(
          color: primaria,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: const Color(0xFF7C8B86),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: _border(borda),
        enabledBorder: _border(borda),
        focusedBorder: _border(primaria, width: 1.6),
        errorBorder: _border(vermelho),
        focusedErrorBorder: _border(vermelho, width: 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaria,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaria,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: const BorderSide(color: Color(0xFFAFC0BA), width: 1.6),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaria
              : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1B2C27),
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        actionTextColor: const Color(0xFF7FD1B9),
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: borda,
        constraints: BoxConstraints(maxWidth: 640),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borda,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
