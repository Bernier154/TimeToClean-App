import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 10, 56, 28);
const palePrimaryColor = Color.fromARGB(255, 93, 142, 126);
const bgColor = Color.fromARGB(255, 251, 252, 253);

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Lato',
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 30,
      color: primaryColor,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      color: primaryColor,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: TextStyle(
      fontSize: 18,
      color: primaryColor,
      fontWeight: FontWeight.w700,
    ),
  ),
);
