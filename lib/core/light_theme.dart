import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme(ColorScheme? lightColorScheme) {
  return ThemeData.light().copyWith(
    useMaterial3: true,
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: lightColorScheme,
  );
}
