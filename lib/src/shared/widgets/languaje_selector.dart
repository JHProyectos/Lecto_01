import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 20),
            const SizedBox(width: 4),
            Text(context.locale.languageCode.toUpperCase()),
          ],
        ),
      ),
      onSelected: (Locale locale) {
        context.setLocale(locale);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('es'),
          child: const Text('Español'),
        ),
        PopupMenuItem(
          value: const Locale('en'),
          child: const Text('English'),
        ),
      ],
    );
  }
}
