import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme(ColorScheme? darkColorScheme, BuildContext context) {
  return ThemeData.dark().copyWith(
    useMaterial3: true,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme?.surface,
  );
}
