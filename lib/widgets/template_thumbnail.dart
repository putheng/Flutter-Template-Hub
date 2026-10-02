import 'package:flutter/material.dart';

import '../models/app_template.dart';
import '../theme/theme.dart';

/// Network-backed preview image for a template with a graceful
/// gradient placeholder while loading or if the image fails.
class TemplateThumbnail extends StatelessWidget {
  const TemplateThumbnail({super.key, required this.template, this.height});

  final AppTemplate template;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      template.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _Placeholder(template: template, loading: true);
      },
      errorBuilder: (context, error, stackTrace) =>
          _Placeholder(template: template),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.template, this.loading = false});

  final AppTemplate template;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final accent = template.category.accent;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: 0.35), AppColors.surfaceElevated],
        ),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(template.category.icon, size: 36, color: Colors.white70),
      ),
    );
  }
}
