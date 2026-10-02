import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_template.dart';
import '../providers/template_providers.dart';
import '../theme/theme.dart';
import 'template_detail_dialog.dart';
import 'template_thumbnail.dart';

/// A single template listing: preview image, title, description,
/// price, license and category.
///
/// The template is read from [currentTemplateProvider], which the parent list
/// must override per item with a `ProviderScope`.
class TemplateCard extends ConsumerWidget {
  const TemplateCard({super.key, this.onTap});

  /// Called when the card is tapped. Defaults to opening the detail dialog.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = ref.watch(currentTemplateProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => TemplateDetailDialog.show(context, template),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Preview(template: template),
            Expanded(child: _Details(template: template)),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.template});

  final AppTemplate template;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TemplateThumbnail(template: template),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0x99000000)],
                stops: [0.55, 1],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            top: AppSpacing.md,
            child: _Tag(
              icon: template.category.icon,
              label: template.category.label,
              color: template.category.accent,
            ),
          ),
          if (template.isNew)
            const Positioned(
              right: AppSpacing.md,
              top: AppSpacing.md,
              child: _Tag(label: 'NEW', color: AppColors.success),
            ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.template});

  final AppTemplate template;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.title,
            style: AppTypography.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            template.description,
            style: AppTypography.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                template.priceLabel,
                style: AppTypography.headlineSmall.copyWith(
                  color: template.isFree
                      ? AppColors.success
                      : AppColors.primary,
                ),
              ),
              const Spacer(),
              Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
              const SizedBox(width: AppSpacing.xxs),
              Text(template.rating.toStringAsFixed(1), style: AppTypography.labelMedium),
              const SizedBox(width: AppSpacing.md),
              Icon(Icons.download_rounded, size: 15, color: AppColors.textTertiary),
              const SizedBox(width: AppSpacing.xxs),
              Text(template.downloadsLabel, style: AppTypography.labelMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: AppSpacing.md),
          _LicenseRow(license: template.license),
        ],
      ),
    );
  }
}

class _LicenseRow extends StatelessWidget {
  const _LicenseRow({required this.license});

  final TemplateLicense license;

  Color get _color => switch (license) {
    TemplateLicense.personal => AppColors.info,
    TemplateLicense.commercial => AppColors.success,
    TemplateLicense.extended => AppColors.warning,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.verified_user_outlined, size: 15, color: _color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          license.label,
          style: AppTypography.labelMedium.copyWith(color: _color),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            license.description,
            style: AppTypography.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.72),
        borderRadius: AppRadius.smAll,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
