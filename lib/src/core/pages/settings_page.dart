import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('toggleTheme'.tr()),
              trailing: Switch(
                value: themeProvider.isDarkTheme,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
            ),
            ListTile(
              title: Text('changeLanguage'.tr()),
              trailing: DropdownButton<Locale>(
                value: context.locale,
                items: const [
                  DropdownMenuItem(value: Locale('en'), child: Text('English')),
                  DropdownMenuItem(value: Locale('es'), child: Text('Español')),
                ],
                onChanged: (newLocale) {
                  if (newLocale != null) {
                    context.setLocale(newLocale);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
