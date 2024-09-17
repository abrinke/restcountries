import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restcountries/provider/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _toggleThemeMode(BuildContext context) {
    Provider.of<ThemeProvider>(context, listen: false).toggleThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Where in the world?'),
      actions: [
        TextButton.icon(
          icon: Icon(
            Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
          label: Text(
            Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                ? 'Light Mode'
                : 'Dark Mode',
          ),
          onPressed: () => _toggleThemeMode(context),
        )
      ],
    );
  }
}