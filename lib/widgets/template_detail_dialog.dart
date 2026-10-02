import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_template.dart';
import '../providers/template_providers.dart';
import '../theme/theme.dart';
import 'template_thumbnail.dart';

/// Modal product detail for a template, with a related-templates rail.
class TemplateDetailDialog extends ConsumerStatefulWidget {
  const TemplateDetailDialog({super.key, required this.template});

  final AppTemplate template;

  static Future<void> show(BuildContext context, AppTemplate template) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (_) => TemplateDetailDialog(template: template),
    );
  }

  @override
  ConsumerState<TemplateDetailDialog> createState() =>
      _TemplateDetailDialogState();
}

class _TemplateDetailDialogState extends ConsumerState<TemplateDetailDialog> {
  final ScrollController _scrollController = ScrollController();

  late AppTemplate _template = widget.template;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectRelated(AppTemplate template) {
    setState(() => _template = template);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: AppDurations.normal,
        curve: Curves.easeOut,
      );
    }
  }

  void _purchase() {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(content: Text('${_template.title} added to your library')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final related = ref.watch(relatedTemplatesProvider(_template.id));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 760,
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: AppRadius.xlAll,
            border: Border.fromBorderSide(
              BorderSide(color: AppColors.border),
            ),
          ),
          child: ClipRRect(
            borderRadius: AppRadius.xlAll,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(template: _template),
                Flexible(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TitleRow(template: _template),
                          const SizedBox(height: AppSpacing.md),
                          _MetaRow(template: _template),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            _template.description,
                            style: AppTypography.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _LicenseCard(license: _template.license),
                          const SizedBox(height: AppSpacing.xl),
                          const _IncludedList(),
                          const SizedBox(height: AppSpacing.xl),
                          _Actions(
                            template: _template,
                            onPurchase: _purchase,
                            onPreview: () => ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text('Launching ${_template.title}…'),
                              ),
                            ),
                          ),
                          if (related.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xxl),
                            const Divider(),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'Related templates',
                              style: AppTypography.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            SizedBox(
                              height: 168,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: related.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: AppSpacing.md),
                                itemBuilder: (context, index) {
                                  final item = related[index];
                                  return _RelatedCard(
                                    template: item,
                                    onTap: () => _selectRelated(item),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.template});

  final AppTemplate template;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TemplateThumbnail(template: template),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Colors.transparent, Color(0xCC000000)],
                stops: [0, 0.45, 1],
              ),
            ),
          ),
          Positioned(
            right: AppSpacing.md,
            top: AppSpacing.md,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.background.withValues(alpha: 0.6),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.xl,
            bottom: AppSpacing.lg,
            child: Wrap(
              spacing: AppSpacing.sm,
              children: [
                _Badge(
                  icon: template.category.icon,
                  label: template.category.label,
                  color: template.category.accent,
                ),
                if (template.isNew)
                  const _Badge(label: 'NEW', color: AppColors.success),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.template});

  final AppTemplate template;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(template.title, style: AppTypography.headlineMedium),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          template.priceLabel,
          style: AppTypography.headlineMedium.copyWith(
            color: template.isFree ? AppColors.success : AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.template});

  final AppTemplate template;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        _MetaItem(
          icon: Icons.star_rounded,
          color: AppColors.warning,
          label: '${template.rating.toStringAsFixed(1)} rating',
        ),
        _MetaItem(
          icon: Icons.download_rounded,
          color: AppColors.info,
          label: '${template.downloadsLabel} downloads',
        ),
        _MetaItem(
          icon: Icons.verified_user_outlined,
          color: AppColors.success,
          label: '${template.license.label} license',
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTypography.labelMedium),
      ],
    );
  }
}

class _LicenseCard extends StatelessWidget {
  const _LicenseCard({required this.license});

  final TemplateLicense license;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: const BoxDecoration(
              color: AppColors.primarySubtle,
              borderRadius: AppRadius.mdAll,
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              size: 19,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${license.label} license',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(license.description, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncludedList extends StatelessWidget {
  const _IncludedList();

  static const List<(IconData, String)> _items = [
    (Icons.code_rounded, 'Full Flutter source code'),
    (Icons.brush_outlined, 'Figma design system'),
    (Icons.system_update_alt_rounded, 'Free lifetime updates'),
    (Icons.support_agent_rounded, '6 months of support'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What\'s included', style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.md),
        for (final (icon, label) in _items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 17,
                  color: AppColors.success,
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(icon, size: 16, color: AppColors.textTertiary),
                const SizedBox(width: AppSpacing.sm),
                Text(label, style: AppTypography.bodyMedium),
              ],
            ),
          ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.template,
    required this.onPurchase,
    required this.onPreview,
  });

  final AppTemplate template;
  final VoidCallback onPurchase;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onPurchase,
            child: Text(
              template.isFree ? 'Get for free' : 'Get template · ${template.priceLabel}',
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: onPreview,
          icon: const Icon(Icons.open_in_new_rounded, size: 16),
          label: const Text('Live preview'),
        ),
      ],
    );
  }
}

class _RelatedCard extends StatelessWidget {
  const _RelatedCard({required this.template, required this.onTap});

  final AppTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 92,
                child: TemplateThumbnail(template: template),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.title,
                        style: AppTypography.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            template.priceLabel,
                            style: AppTypography.titleSmall.copyWith(
                              color: template.isFree
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            template.rating.toStringAsFixed(1),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.icon});

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
