import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restcountries/colors/app_colors.dart';
import 'package:restcountries/home_widget.dart';
import 'package:restcountries/provider/theme_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MainApp(),
  ),);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      home: const HomeWidget(),
    );
  }
}

