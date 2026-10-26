import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_repo/home_repo_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source_implement.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_products_entites.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_case/get_product_by_id_use_case.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' show Either;

import 'product_details_screen.dart';

class ProductDetailsRouteScreen extends StatefulWidget {
  const ProductDetailsRouteScreen({
    required this.productId,
    this.expectedCategoryId,
    super.key,
  });

  final int productId;
  final int? expectedCategoryId;

  @override
  State<ProductDetailsRouteScreen> createState() =>
      _ProductDetailsRouteScreenState();
}

class _ProductDetailsRouteScreenState extends State<ProductDetailsRouteScreen> {
  late final Future<Either<Failure, HomeProductEntites>> _productFuture;

  @override
  void initState() {
    super.initState();
    final apiClient = ApiClient();
    final useCase = GetProductByIdUseCase(
      HomeRepoImp(HomeRemoteDataSourceImplement(apiClient: apiClient)),
    );
    _productFuture = useCase.invoke(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) {
          return const _ProductUnavailableScreen();
        }

        final result = snapshot.data!;
        return result.fold<Widget>((_) => const _ProductUnavailableScreen(), (
          product,
        ) {
          if (widget.expectedCategoryId != null &&
              product.category.id != widget.expectedCategoryId) {
            return const _ProductUnavailableScreen();
          }
          return ProductDetailsScreen(productModel: product);
        });
      },
    );
  }
}

class _ProductUnavailableScreen extends StatelessWidget {
  const _ProductUnavailableScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product unavailable')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'This product could not be found. It may have been removed.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
