import 'package:flutter/material.dart';

/// A category a mobile app template belongs to.
enum TemplateCategory {
  ecommerce('E-commerce', Icons.shopping_bag_outlined, Color(0xFF6E7CF6)),
  social('Social', Icons.people_outline, Color(0xFF60A5FA)),
  productivity('Productivity', Icons.checklist_outlined, Color(0xFF34D399)),
  finance('Finance', Icons.account_balance_wallet_outlined, Color(0xFFFBBF24)),
  health('Health', Icons.favorite_border, Color(0xFFF87171)),
  education('Education', Icons.school_outlined, Color(0xFFA78BFA)),
  travel('Travel', Icons.flight_takeoff_outlined, Color(0xFF22D3EE)),
  food('Food & Drink', Icons.restaurant_outlined, Color(0xFFFB923C));

  const TemplateCategory(this.label, this.icon, this.accent);

  final String label;
  final IconData icon;
  final Color accent;
}

/// The license bundled with a template.
enum TemplateLicense {
  personal('Personal', 'One personal project'),
  commercial('Commercial', 'Unlimited client projects'),
  extended('Extended', 'Resale & redistribution');

  const TemplateLicense(this.label, this.description);

  final String label;
  final String description;
}

/// Ordering options for the template browser.
enum TemplateSort {
  popular('Most popular'),
  newest('Newest'),
  topRated('Top rated'),
  priceLow('Price: low to high'),
  priceHigh('Price: high to low');

  const TemplateSort(this.label);

  final String label;
}

/// A pre-made mobile app template listing.
@immutable
class AppTemplate {
  const AppTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.license,
    required this.rating,
    required this.downloads,
    this.isNew = false,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final TemplateCategory category;
  final TemplateLicense license;
  final double rating;
  final int downloads;
  final bool isNew;

  bool get isFree => price == 0;

  String get priceLabel => isFree ? 'Free' : '\$${price.toStringAsFixed(0)}';

  String get downloadsLabel {
    if (downloads >= 1000) {
      return '${(downloads / 1000).toStringAsFixed(1)}k';
    }
    return '$downloads';
  }
}

/// The active filter selection for the template browser.
@immutable
class TemplateFilters {
  const TemplateFilters({
    this.priceRange = const RangeValues(0, maxPrice),
    this.categories = const <TemplateCategory>{},
    this.licenses = const <TemplateLicense>{},
  });

  static const double maxPrice = 100;

  final RangeValues priceRange;
  final Set<TemplateCategory> categories;
  final Set<TemplateLicense> licenses;

  bool get isEmpty =>
      priceRange.start == 0 &&
      priceRange.end == maxPrice &&
      categories.isEmpty &&
      licenses.isEmpty;

  int get activeCount =>
      (priceRange.start != 0 || priceRange.end != maxPrice ? 1 : 0) +
      categories.length +
      licenses.length;

  bool matches(AppTemplate template) {
    if (template.price < priceRange.start || template.price > priceRange.end) {
      return false;
    }
    if (categories.isNotEmpty && !categories.contains(template.category)) {
      return false; 
    }
    if (licenses.isNotEmpty && !licenses.contains(template.license)) {
      return false;
    }
    return true;
  }

  TemplateFilters copyWith({
    RangeValues? priceRange,
    Set<TemplateCategory>? categories,
    Set<TemplateLicense>? licenses,
  }) {
    return TemplateFilters(
      priceRange: priceRange ?? this.priceRange,
      categories: categories ?? this.categories,
      licenses: licenses ?? this.licenses,
    );
  }

  TemplateFilters toggleCategory(TemplateCategory category) {
    final next = Set<TemplateCategory>.of(categories);
    next.contains(category) ? next.remove(category) : next.add(category);
    return copyWith(categories: next);
  }

  TemplateFilters toggleLicense(TemplateLicense license) {
    final next = Set<TemplateLicense>.of(licenses);
    next.contains(license) ? next.remove(license) : next.add(license);
    return copyWith(licenses: next);
  }
}
