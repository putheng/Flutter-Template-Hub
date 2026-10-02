# TemplateHub

A Flutter UI for browsing pre-made mobile app templates, styled as a
dark-mode marketplace. Users browse a grid of templates, narrow them with
filters, and open a product detail dialog with related recommendations.

## Features

- Responsive grid of template cards showing preview image, title,
  description, price, license and category.
- Left sidebar filters for **price** (range slider + presets), **category**
  and **license**; collapses into a bottom sheet on narrow screens.
- Search by title, description or category, plus sorting by popularity,
  newest, top rated and price.
- Product detail dialog with image header, metadata, license details,
  what's-included list, purchase/preview actions and a related-templates rail.
- Graceful image placeholders while loading or on error.
- Dark design-system theme (colors, typography, spacing, radius, motion).

## Architecture

State is managed with [Riverpod](https://riverpod.dev) (`flutter_riverpod`).

| Provider | Responsibility |
| --- | --- |
| `templatesProvider` | Source catalog of templates |
| `templateFiltersProvider` | Filter selection (`Notifier`) |
| `filteredTemplatesProvider` | Templates matching the active filters |
| `browsedTemplatesProvider` | Filtered list + search/sort (family, keyed by query) |
| `relatedTemplatesProvider` | Related templates for a given id (family) |
| `currentTemplateProvider` | Template rendered by a grid item, overridden per item via `ProviderScope` |

Search and sort are keyed family arguments; per-item template data is injected
through a scoped `ProviderScope` override rather than passed as a constructor
argument.

### Project layout

```
lib/
  main.dart                     App entry (ProviderScope + MaterialApp)
  data/sample_templates.dart    Placeholder catalog
  models/app_template.dart      AppTemplate, filters, categories, licenses, sort
  providers/template_providers.dart
  screens/template_browser_screen.dart
  theme/                        Design tokens and ThemeData
  widgets/
    filter_sidebar.dart
    template_card.dart
    template_detail_dialog.dart
    template_thumbnail.dart
```

## Getting started

```bash
flutter pub get
flutter run            # add -d macos / -d chrome / -d <device>
```

### macOS networking

Template images are fetched over the network. The macOS sandbox entitlements
include `com.apple.security.network.client` in both
`macos/Runner/DebugProfile.entitlements` and
`macos/Runner/Release.entitlements`. If images show as placeholders on macOS,
ensure that key is present and rebuild (entitlements are applied at build
time, not on hot reload).

## Tests

```bash
flutter test
flutter analyze
```

Widget tests cover the catalog render, the filter sheet sections, and opening
the detail dialog with related items.
