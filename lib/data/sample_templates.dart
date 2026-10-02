import '../models/app_template.dart';

/// Placeholder catalog used for the template browser UI.
const List<AppTemplate> sampleTemplates = [
  AppTemplate(
    id: 'shoply',
    title: 'Shoply Commerce',
    description:
        'A complete storefront with cart, checkout, wishlists and order tracking flows.',
    imageUrl:
        'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=600&h=300&fit=crop&q=80&auto=format',
    price: 49,
    category: TemplateCategory.ecommerce,
    license: TemplateLicense.commercial,
    rating: 4.8,
    downloads: 12400,
  ),
  AppTemplate(
    id: 'pulse',
    title: 'Pulse Social',
    description:
        'Feed, stories, direct messages and live presence for a modern social app.',
    imageUrl:
        'https://images.unsplash.com/photo-1551721434-8b94ddff0e6d?w=600&h=300&fit=crop&q=80&auto=format',
    price: 0,
    category: TemplateCategory.social,
    license: TemplateLicense.personal,
    rating: 4.5,
    downloads: 38200,
    isNew: true,
  ),
  AppTemplate(
    id: 'focusflow',
    title: 'FocusFlow',
    description:
        'Task manager with kanban boards, reminders, tags and offline-first sync.',
    imageUrl:
        'https://images.unsplash.com/photo-1609921141835-710b7fa6e438?w=600&h=300&fit=crop&q=80&auto=format',
    price: 29,
    category: TemplateCategory.productivity,
    license: TemplateLicense.personal,
    rating: 4.6,
    downloads: 8700,
  ),
  AppTemplate(
    id: 'walletwise',
    title: 'WalletWise',
    description:
        'Personal finance tracker with budgets, insights charts and recurring bills.',
    imageUrl:
        'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600&h=300&fit=crop&q=80&auto=format',
    price: 59,
    category: TemplateCategory.finance,
    license: TemplateLicense.extended,
    rating: 4.9,
    downloads: 5600,
  ),
  AppTemplate(
    id: 'vitalis',
    title: 'Vitalis Health',
    description:
        'Activity rings, workout plans and health logging with a calm, clinical look.',
    imageUrl:
        'https://images.unsplash.com/photo-1731690435374-5d8b4f1a3d47?w=600&h=300&fit=crop&q=80&auto=format',
    price: 39,
    category: TemplateCategory.health,
    license: TemplateLicense.commercial,
    rating: 4.4,
    downloads: 4100,
  ),
  AppTemplate(
    id: 'scholarly',
    title: 'Scholarly',
    description:
        'Course catalog, video lessons, quizzes and progress tracking for learners.',
    imageUrl:
        'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=600&h=300&fit=crop&q=80&auto=format',
    price: 0,
    category: TemplateCategory.education,
    license: TemplateLicense.personal,
    rating: 4.3,
    downloads: 21500,
  ),
  AppTemplate(
    id: 'wanderly',
    title: 'Wanderly Travel',
    description:
        'Discover destinations, build itineraries and book stays in a single flow.',
    imageUrl:
        'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&h=300&fit=crop&q=80&auto=format',
    price: 45,
    category: TemplateCategory.travel,
    license: TemplateLicense.commercial,
    rating: 4.7,
    downloads: 6900,
    isNew: true,
  ),
  AppTemplate(
    id: 'crave',
    title: 'Crave Delivery',
    description:
        'Restaurant listings, menus, live order status and driver tracking screens.',
    imageUrl:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&h=300&fit=crop&q=80&auto=format',
    price: 69,
    category: TemplateCategory.food,
    license: TemplateLicense.extended,
    rating: 4.6,
    downloads: 3900,
  ),
  AppTemplate(
    id: 'marketplace',
    title: 'Marketplace Pro',
    description:
        'Multi-vendor marketplace with seller dashboards, payouts and reviews.',
    imageUrl:
        'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?w=600&h=300&fit=crop&q=80&auto=format',
    price: 89,
    category: TemplateCategory.ecommerce,
    license: TemplateLicense.extended,
    rating: 4.9,
    downloads: 2700,
  ),
  AppTemplate(
    id: 'chatter',
    title: 'Chatter Rooms',
    description:
        'Realtime group chat, threads, reactions and media sharing out of the box.',
    imageUrl:
        'https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?w=600&h=300&fit=crop&q=80&auto=format',
    price: 19,
    category: TemplateCategory.social,
    license: TemplateLicense.personal,
    rating: 4.2,
    downloads: 15300,
  ),
  AppTemplate(
    id: 'ledger',
    title: 'Ledger Bank',
    description:
        'Neo-banking UI with cards, transfers, statements and biometric auth.',
    imageUrl:
        'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=600&h=300&fit=crop&q=80&auto=format',
    price: 99,
    category: TemplateCategory.finance,
    license: TemplateLicense.extended,
    rating: 5.0,
    downloads: 1800,
    isNew: true,
  ),
  AppTemplate(
    id: 'nomnom',
    title: 'NomNom Recipes',
    description:
        'Recipe discovery, guided cooking steps and shopping list generation.',
    imageUrl:
        'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=600&h=300&fit=crop&q=80&auto=format',
    price: 0,
    category: TemplateCategory.food,
    license: TemplateLicense.personal,
    rating: 4.1,
    downloads: 9800,
  ),
];
