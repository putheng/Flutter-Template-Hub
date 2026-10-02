import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:template/main.dart';
import 'package:template/widgets/template_card.dart';
import 'package:template/widgets/template_detail_dialog.dart';

void main() {
  testWidgets('template browser renders catalog and filters', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: TemplateHubApp()),
    );
    await tester.pump();

    expect(find.text('TemplateHub'), findsOneWidget);
    expect(find.text('Mobile App Templates'), findsOneWidget);
    expect(find.byType(TemplateCard), findsWidgets);
  });

  testWidgets('opening the filter sheet shows filter sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: TemplateHubApp()),
    );
    await tester.pump();

    await tester.tap(find.text('Filters').last);
    await tester.pumpAndSettle();

    expect(find.text('PRICE'), findsOneWidget);
    expect(find.text('CATEGORY'), findsOneWidget);

    final sheetScrollable = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('LICENSE'),
      200,
      scrollable: sheetScrollable,
    );
    expect(find.text('LICENSE'), findsOneWidget);
  });

  testWidgets('tapping a card opens the detail dialog with related items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: TemplateHubApp()),
    );
    await tester.pump();

    await tester.tap(find.byType(TemplateCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(TemplateDetailDialog), findsOneWidget);

    final dialogScrollable = find
        .descendant(
          of: find.byType(TemplateDetailDialog),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('Related templates'),
      300,
      scrollable: dialogScrollable,
    );
    expect(find.text('Related templates'), findsOneWidget);
  });
}
