import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repo/home_repo.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentaton/view/home_screen.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentaton/view_model/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders products returned by the repository', (tester) async {
    final repository = await _pumpHome(
      tester,
      products: [
        HomeProductEntites(
          id: 1,
          title: 'Mountain T-shirt',
          price: 44,
          images: const [],
        ),
      ],
    );

    expect(find.text('Mountain T-shirt'), findsOneWidget);
    expect(repository.productRequests, [(categoryId: 1, limit: 10, offset: 0)]);
  });

  testWidgets('shows an empty state when no products are returned', (
    tester,
  ) async {
    await _pumpHome(tester);

    expect(find.text('No products found'), findsOneWidget);
  });

  testWidgets('shows loading while products are being fetched', (tester) async {
    final productsCompleter =
        Completer<Either<Failure, List<HomeProductEntites>>>();
    final repository = _HomeRepository(
      categories: const [HomeCategoryEntites(id: 1, name: 'Clothing')],
      products: const [],
      productsCompleter: productsCompleter,
    );
    final cubit = HomeCubit(
      getCategoriesUseCase: GetCategoriesUseCase(repository),
      getProductsUseCase: GetProductsUseCase(repository),
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const HomeScreen()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    productsCompleter.complete(const Right([]));
    await tester.pumpAndSettle();
    expect(find.text('No products found'), findsOneWidget);
  });

  testWidgets(
    'handles an empty category response without fetching category 0',
    (tester) async {
      final repository = await _pumpHome(tester, categories: const []);

      expect(find.text('No categories found'), findsOneWidget);
      expect(find.text('No products found'), findsOneWidget);
      expect(repository.requestedCategoryIds, isEmpty);
    },
  );

  testWidgets('shows product request errors', (tester) async {
    await _pumpHome(
      tester,
      productFailure: const Failure(failureMessage: 'Unavailable'),
    );

    expect(find.text('Unavailable'), findsOneWidget);
  });
}

Future<_HomeRepository> _pumpHome(
  WidgetTester tester, {
  List<HomeCategoryEntites> categories = const [
    HomeCategoryEntites(id: 1, name: 'Clothing'),
  ],
  List<HomeProductEntites> products = const [],
  Failure? productFailure,
}) async {
  final repository = _HomeRepository(
    categories: categories,
    products: products,
    productFailure: productFailure,
  );
  final cubit = HomeCubit(
    getCategoriesUseCase: GetCategoriesUseCase(repository),
    getProductsUseCase: GetProductsUseCase(repository),
  );
  addTearDown(cubit.close);

  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(value: cubit, child: const HomeScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

class _HomeRepository implements HomeRepo {
  _HomeRepository({
    required this.categories,
    required this.products,
    this.productsCompleter,
    this.productFailure,
  });

  final List<HomeCategoryEntites> categories;
  final List<HomeProductEntites> products;
  final Completer<Either<Failure, List<HomeProductEntites>>>? productsCompleter;
  final Failure? productFailure;
  final requestedCategoryIds = <int?>[];
  final productRequests = <({int categoryId, int limit, int offset})>[];

  @override
  Future<Either<Failure, List<HomeCategoryEntites>>> getCategoriesRepo() async {
    return Right(categories);
  }

  @override
  Future<Either<Failure, HomeProductEntites>> getProductByIdRepo(
    int productId,
  ) async {
    return const Left(Failure(failureMessage: 'Not found'));
  }

  @override
  Future<Either<Failure, List<HomeProductEntites>>> getProductsRepo(
    int categoryId, {
    required int limit,
    required int offset,
  }) async {
    requestedCategoryIds.add(categoryId);
    productRequests.add((categoryId: categoryId, limit: limit, offset: offset));
    if (productsCompleter != null) {
      return productsCompleter!.future;
    }
    if (productFailure case final failure?) {
      return Left(failure);
    }
    return Right(products);
  }
}
