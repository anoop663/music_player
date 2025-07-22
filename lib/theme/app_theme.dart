import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Colors.white;
  static const Color backgroundColor = Colors.black;
  static const Color appBarColor = Colors.black;
  static const Color bodyColor = Color.fromARGB(255, 10, 10, 10);
  static const Color workareaColor = Color.fromARGB(255, 22, 22, 22);
  static const Color textColor = Colors.white;
  static const Color subtitleColor = Color(0xFFBCBCBC);
  

  // Global Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarColor,
      foregroundColor: textColor,
    ),
    textTheme: GoogleFonts.robotoTextTheme(
      ThemeData.dark().textTheme.apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      surface: backgroundColor,
    ),
  );

  // Custom TextStyles
  static TextStyle robotoLight(double size) => GoogleFonts.roboto(
    fontSize: size,
    fontWeight: FontWeight.w300,
    color: textColor,
  );

  static TextStyle robotoRegular(double size) => GoogleFonts.roboto(
    fontSize: size,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static TextStyle robotoBold(double size) => GoogleFonts.roboto(
    fontSize: size,
    fontWeight: FontWeight.w700,
    color: textColor,
  );
  static TextStyle robotoSubtitiles(double size) => GoogleFonts.roboto(
    fontSize: size,
    fontWeight: FontWeight.w500,
    color: subtitleColor,
  );
}
