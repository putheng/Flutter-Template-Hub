import 'package:flutter/material.dart';

import '../models/app_template.dart';
import '../theme/theme.dart';

/// Left-hand filter panel with price, category and license controls.
class FilterSidebar extends StatelessWidget {
  const FilterSidebar({
    super.key,
    required this.filters,
    required this.onChanged,
    this.resultCount,
  });

  final TemplateFilters filters;
  final ValueChanged<TemplateFilters> onChanged;
  final int? resultCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Text('Filters', style: AppTypography.headlineSmall),
              const Spacer(),
              if (resultCount != null)
                Text('$resultCount', style: AppTypography.labelMedium),
              if (!filters.isEmpty) const SizedBox(width: AppSpacing.sm),
              if (!filters.isEmpty)
                TextButton(
                  onPressed: () => onChanged(const TemplateFilters()),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                  ),
                  child: const Text('Clear all'),
                ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.xxl,
            ),
            children: [
              _SectionTitle('Price'),
              const SizedBox(height: AppSpacing.sm),
              _PriceFilter(
                value: filters.priceRange,
                onChanged: (range) =>
                    onChanged(filters.copyWith(priceRange: range)),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
              _SectionTitle('Category'),
              const SizedBox(height: AppSpacing.xs),
              for (final category in TemplateCategory.values)
                _CheckTile(
                  label: category.label,
                  icon: category.icon,
                  selected: filters.categories.contains(category),
                  onTap: () => onChanged(filters.toggleCategory(category)),
                ),
              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
              _SectionTitle('License'),
              const SizedBox(height: AppSpacing.xs),
              for (final license in TemplateLicense.values)
                _CheckTile(
                  label: license.label,
                  subtitle: license.description,
                  selected: filters.licenses.contains(license),
                  onTap: () => onChanged(filters.toggleLicense(license)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTypography.labelSmall.copyWith(letterSpacing: 0.8),
    );
  }
}

class _PriceFilter extends StatelessWidget {
  const _PriceFilter({required this.value, required this.onChanged});

  final RangeValues value;
  final ValueChanged<RangeValues> onChanged;

  static const List<(String, RangeValues)> _presets = [
    ('All', RangeValues(0, TemplateFilters.maxPrice)),
    ('Free', RangeValues(0, 0)),
    ('Under \$30', RangeValues(0, 30)),
    ('\$30–\$70', RangeValues(30, 70)),
    ('\$70+', RangeValues(70, TemplateFilters.maxPrice)),
  ];

  String _price(double v) => v <= 0 ? 'Free' : '\$${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              _price(value.start),
              style: AppTypography.titleMedium,
            ),
            const Spacer(),
            Text(_price(value.end), style: AppTypography.titleMedium),
          ],
        ),
        RangeSlider(
          values: value,
          min: 0,
          max: TemplateFilters.maxPrice,
          divisions: 20,
          labels: RangeLabels(_price(value.start), _price(value.end)),
          onChanged: onChanged,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final (label, range) in _presets)
              _PresetChip(
                label: label,
                selected: value == range,
                onTap: () => onChanged(range),
              ),
          ],
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.smAll,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySubtle : AppColors.surfaceElevated,
          borderRadius: AppRadius.smAll,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  const _CheckTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            _Checkbox(selected: selected),
            const SizedBox(width: AppSpacing.md),
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTypography.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fast,
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: AppRadius.smAll,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderStrong,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 13, color: AppColors.onPrimary)
          : null,
    );
  }
}
