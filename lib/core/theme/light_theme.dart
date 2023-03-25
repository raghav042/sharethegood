import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme(ColorScheme? lightColorScheme) {
  return ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: GoogleFonts.nunitoTextTheme(),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
  );
}
