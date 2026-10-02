import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_template.dart';
import '../providers/template_providers.dart';
import '../theme/theme.dart';
import '../widgets/filter_sidebar.dart';
import '../widgets/template_card.dart';

/// Marketplace screen for browsing pre-made mobile app templates.
class TemplateBrowserScreen extends ConsumerStatefulWidget {
  const TemplateBrowserScreen({super.key});

  @override
  ConsumerState<TemplateBrowserScreen> createState() =>
      _TemplateBrowserScreenState();
}

class _TemplateBrowserScreenState extends ConsumerState<TemplateBrowserScreen> {
  final TextEditingController _searchController = TextEditingController();

  TemplateSort _sort = TemplateSort.popular;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearAll() {
    ref.read(templateFiltersProvider.notifier).clear();
    _searchController.clear();
    setState(() => _query = '');
  }

  void _openFilters() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Consumer(
          builder: (context, ref, _) {
            final filters = ref.watch(templateFiltersProvider);
            final count = ref.watch(filteredTemplatesProvider).length;
            return FilterSidebar(
              filters: filters,
              resultCount: count,
              onChanged: ref.read(templateFiltersProvider.notifier).set,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(templateFiltersProvider);
    final results = ref.watch(
      browsedTemplatesProvider((query: _query, sort: _sort)),
    );
    final total = ref.watch(templatesProvider).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1000;

        return Scaffold(
          appBar: AppBar(
            titleSpacing: AppSpacing.xl,
            title: const _Brand(),
            actions: [
              if (!wide)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: _FilterButton(
                    count: filters.activeCount,
                    onPressed: _openFilters,
                  ),
                ),
              const SizedBox(width: AppSpacing.lg),
            ],
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (wide)
                SizedBox(
                  width: 272,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        right: BorderSide(color: AppColors.divider),
                      ),
                    ),
                    child: FilterSidebar(
                      filters: filters,
                      resultCount: results.length,
                      onChanged: ref
                          .read(templateFiltersProvider.notifier)
                          .set,
                    ),
                  ),
                ),
              Expanded(
                child: _Content(
                  results: results,
                  total: total,
                  sort: _sort,
                  searchController: _searchController,
                  onQueryChanged: (query) => setState(() => _query = query),
                  onSortChanged: (sort) => setState(() => _sort = sort),
                  onClear: _clearAll,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
            color: AppColors.primarySubtle,
            borderRadius: AppRadius.mdAll,
          ),
          child: const Icon(
            Icons.phone_iphone_rounded,
            size: 17,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('TemplateHub', style: AppTypography.headlineSmall),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.tune_rounded, size: 18),
          label: const Text('Filters'),
        ),
        if (count > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.results,
    required this.total,
    required this.sort,
    required this.searchController,
    required this.onQueryChanged,
    required this.onSortChanged,
    required this.onClear,
  });

  final List<AppTemplate> results;
  final int total;
  final TemplateSort sort;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<TemplateSort> onSortChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mobile App Templates', style: AppTypography.headlineLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${results.length} of $total templates',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: onQueryChanged,
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search templates…',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppColors.textTertiary,
                        ),
                        suffixIcon: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () {
                                  searchController.clear();
                                  onQueryChanged('');
                                },
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _SortButton(value: sort, onChanged: onSortChanged),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? _EmptyState(onClear: onClear)
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    0,
                    AppSpacing.xl,
                    AppSpacing.xxl,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 360,
                        mainAxisExtent: 344,
                        crossAxisSpacing: AppSpacing.lg,
                        mainAxisSpacing: AppSpacing.lg,
                      ),
                  itemCount: results.length,
                  itemBuilder: (context, index) => ProviderScope(
                    overrides: [
                      currentTemplateProvider.overrideWithValue(
                        results[index],
                      ),
                    ],
                    child: const TemplateCard(),
                  ),
                ),
        ),
      ],
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.value, required this.onChanged});

  final TemplateSort value;
  final ValueChanged<TemplateSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TemplateSort>(
      initialValue: value,
      onSelected: onChanged,
      color: AppColors.surfaceElevated,
      position: PopupMenuPosition.under,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.mdAll,
        side: BorderSide(color: AppColors.border),
      ),
      itemBuilder: (context) => [
        for (final sort in TemplateSort.values)
          PopupMenuItem(
            value: sort,
            child: Row(
              children: [
                Icon(
                  sort == value
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 16,
                  color: sort == value
                      ? AppColors.primary
                      : AppColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(sort.label, style: AppTypography.bodyMedium),
              ],
            ),
          ),
      ],
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.swap_vert_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(value.label, style: AppTypography.labelLarge),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.expand_more_rounded,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              color: AppColors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('No templates found', style: AppTypography.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try adjusting your filters or search terms.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.tonal(
            onPressed: onClear,
            child: const Text('Reset filters'),
          ),
        ],
      ),
    );
  }
}
