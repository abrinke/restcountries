import 'package:flutter/material.dart';

class AppColors {
  static const darkBlue = Color(0xFF2B3945);  // Dark Mode Elements
  static const veryDarkBlue = Color(0xFF202C37);  // Dark Mode Background
  static const veryDarkBlueText = Color(0xFF111517);  // Light Mode Text
  static const darkGray = Color(0xFF858585);  // Light Mode Input
  static const veryLightGray = Color(0xFFFAFAFA);  // Light Mode Background
  static const white = Color(0xFFFFFFFF);  // Dark Mode Text & Light Mode Elements
}

class AppTheme {
  static BoxDecoration getContainerDecoration(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: theme.brightness == Brightness.dark ? AppColors.darkBlue : AppColors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: theme.brightness == Brightness.dark
              ? Colors.black.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

ThemeData getLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.veryLightGray,
    scaffoldBackgroundColor: AppColors.veryLightGray,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.veryDarkBlueText,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.veryDarkBlueText),
      bodyMedium: TextStyle(color: AppColors.veryDarkBlueText),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.veryDarkBlueText,
        backgroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.veryDarkBlueText,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(color: AppColors.veryDarkBlueText),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.white),
        elevation: WidgetStateProperty.all(4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.veryDarkBlueText,
        backgroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppColors.white,
      filled: true,
      hintStyle: TextStyle(color: AppColors.darkGray),
    ),
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.veryDarkBlue,
    scaffoldBackgroundColor: AppColors.veryDarkBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBlue,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.darkBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.white,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(color: AppColors.white),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.darkBlue),
        elevation: WidgetStateProperty.all(4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.darkBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.darkBlue,
      filled: true,
      hintStyle: TextStyle(color: AppColors.white.withOpacity(0.7)),
    ),
  );
}