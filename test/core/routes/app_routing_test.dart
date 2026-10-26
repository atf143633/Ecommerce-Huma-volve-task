import 'package:flutter/material.dart';
import 'package:ecommerce_app_huma_volve/core/routes/app_routing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRouting product links', () {
    test('builds an in-app location with route and query parameters', () {
      expect(
        AppRouting.productLocation(42, queryParameters: {'categoryId': '3'}),
        '/products/42?categoryId=3',
      );
    });

    test('builds a shareable custom-scheme deep link', () {
      final deepLink = Uri.parse(
        AppRouting.productDeepLink(42, queryParameters: {'source': 'share'}),
      );

      expect(deepLink.scheme, AppRouting.deepLinkScheme);
      expect(deepLink.host, AppRouting.deepLinkHost);
      expect(deepLink.path, '/products/42');
      expect(deepLink.queryParameters['source'], 'share');
    });

    testWidgets('shows a clear fallback for an invalid product ID', (
      tester,
    ) async {
      AppRouting.router.go('/products/not-a-number');
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: AppRouting.router),
      );
      await tester.pumpAndSettle();

      expect(find.text('This product link is invalid.'), findsOneWidget);
    });

    testWidgets('shows a clear fallback for an unknown route', (tester) async {
      AppRouting.router.go('/unknown');
      await tester.pumpWidget(
        MaterialApp.router(routerConfig: AppRouting.router),
      );
      await tester.pumpAndSettle();

      expect(find.text('This link could not be opened.'), findsOneWidget);
    });
  });
}
