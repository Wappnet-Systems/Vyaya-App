import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    return Switch.adaptive(
      activeColor: Theme.of(context).colorScheme.onPrimary,
      value: provider.themeMode == ThemeMode.dark,
      onChanged: ((value) async {
        final mode = value ? ThemeMode.dark : ThemeMode.light;
        provider.setThemeMode(mode);
      }));
  }
}
