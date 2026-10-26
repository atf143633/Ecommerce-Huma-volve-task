import 'package:ecommerce_app_huma_volve/features/details/screens/product_details_route_screen.dart';
import 'package:ecommerce_app_huma_volve/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouting {
  static const String deepLinkScheme = 'humavolve';
  static const String deepLinkHost = 'app';

  static String productLocation(
    int productId, {
    Map<String, String> queryParameters = const {},
  }) {
    return Uri(
      path: '/products/$productId',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    ).toString();
  }

  static String productDeepLink(
    int productId, {
    Map<String, String> queryParameters = const {},
  }) {
    return Uri(
      scheme: deepLinkScheme,
      host: deepLinkHost,
      path: '/products/$productId',
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    ).toString();
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final productId = int.tryParse(state.pathParameters['id'] ?? '');
          final rawCategoryId = state.uri.queryParameters['categoryId'];
          final categoryId = rawCategoryId == null
              ? null
              : int.tryParse(rawCategoryId);
          if (productId == null ||
              productId <= 0 ||
              (rawCategoryId != null &&
                  (categoryId == null || categoryId <= 0))) {
            return const DeepLinkErrorScreen(
              message: 'This product link is invalid.',
            );
          }
          return ProductDetailsRouteScreen(
            key: ValueKey(productId),
            productId: productId,
            expectedCategoryId: categoryId,
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        const DeepLinkErrorScreen(message: 'This link could not be opened.'),
  );
}

class DeepLinkErrorScreen extends StatelessWidget {
  const DeepLinkErrorScreen({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link_off, size: 48),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
