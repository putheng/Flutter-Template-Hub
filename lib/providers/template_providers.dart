import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_templates.dart';
import '../models/app_template.dart';

/// The source catalog of pre-made mobile app templates.
final templatesProvider = Provider<List<AppTemplate>>(
  (ref) => sampleTemplates,
);

/// Owns the active filter selection for the template browser.
class TemplateFiltersNotifier extends Notifier<TemplateFilters> {
  @override
  TemplateFilters build() => const TemplateFilters();

  void set(TemplateFilters filters) => state = filters;

  void clear() => state = const TemplateFilters();

  void setPriceRange(RangeValues range) =>
      state = state.copyWith(priceRange: range);

  void toggleCategory(TemplateCategory category) =>
      state = state.toggleCategory(category);

  void toggleLicense(TemplateLicense license) =>
      state = state.toggleLicense(license);
}

final templateFiltersProvider =
    NotifierProvider<TemplateFiltersNotifier, TemplateFilters>(
      TemplateFiltersNotifier.new,
    );

/// Templates narrowed down by the active filters.
final filteredTemplatesProvider = Provider<List<AppTemplate>>((ref) {
  final templates = ref.watch(templatesProvider);
  final filters = ref.watch(templateFiltersProvider);
  return templates.where(filters.matches).toList();
});

/// The template rendered by a single template card in a grid item.
///
/// Must be overridden per list item with `ProviderScope` + `overrideWithValue`
/// instead of being passed down as a constructor argument.
final currentTemplateProvider = Provider<AppTemplate>(
  (ref) => throw UnimplementedError(
    'currentTemplateProvider must be overridden for each template item.',
  ),
);

/// Search and ordering parameters for the template browser.
typedef TemplateBrowseQuery = ({String query, TemplateSort sort});

/// Templates narrowed by [filteredTemplatesProvider], matched against the
/// search [TemplateBrowseQuery.query] and ordered by [TemplateBrowseQuery.sort].
///
/// Keyed by the query so results are cached per search/sort combination and
/// released once nothing watches them.
final browsedTemplatesProvider =
    Provider.family<List<AppTemplate>, TemplateBrowseQuery>((ref, query) {
      final filtered = ref.watch(filteredTemplatesProvider);
      final search = query.query.trim().toLowerCase();

      final list = filtered.where((template) {
        if (search.isEmpty) return true;
        return template.title.toLowerCase().contains(search) ||
            template.description.toLowerCase().contains(search) ||
            template.category.label.toLowerCase().contains(search);
      }).toList();

      switch (query.sort) {
        case TemplateSort.popular:
          list.sort((a, b) => b.downloads.compareTo(a.downloads));
        case TemplateSort.newest:
          list.sort((a, b) {
            if (a.isNew == b.isNew) return b.downloads.compareTo(a.downloads);
            return a.isNew ? -1 : 1;
          });
        case TemplateSort.topRated:
          list.sort((a, b) => b.rating.compareTo(a.rating));
        case TemplateSort.priceLow:
          list.sort((a, b) => a.price.compareTo(b.price));
        case TemplateSort.priceHigh:
          list.sort((a, b) => b.price.compareTo(a.price));
      }
      return list;
    }, isAutoDispose: true);

/// Up to [limit] templates related to the one with [templateId]:
/// same category first (best rated), then filled with popular picks.
final relatedTemplatesProvider =
    Provider.family<List<AppTemplate>, String>((ref, templateId) {
      const limit = 4;
      final all = ref.watch(templatesProvider);
      final source = all.firstWhere((t) => t.id == templateId);

      final sameCategory =
          all
              .where((t) => t.id != templateId && t.category == source.category)
              .toList()
            ..sort((a, b) => b.rating.compareTo(a.rating));

      if (sameCategory.length >= limit) {
        return sameCategory.take(limit).toList();
      }

      final fallback =
          all
              .where(
                (t) =>
                    t.id != templateId && t.category != source.category,
              )
              .toList()
            ..sort((a, b) => b.downloads.compareTo(a.downloads));

      return [...sameCategory, ...fallback].take(limit).toList();
    });
