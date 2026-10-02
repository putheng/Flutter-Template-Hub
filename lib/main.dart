import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/template_browser_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: TemplateHubApp()));
}

class TemplateHubApp extends StatelessWidget {
  const TemplateHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TemplateHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const TemplateBrowserScreen(),
    );
  }
}
