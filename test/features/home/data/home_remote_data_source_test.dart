import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constant/api_constant.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source_implement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('requests categories and maps the response', () async {
    final dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
    RequestOptions? request;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: [
                {'id': 2, 'name': 'Electronics'},
              ],
            ),
          );
        },
      ),
    );

    final dataSource = HomeRemoteDataSourceImplement(
      apiClient: ApiClient()..dio = dio,
    );
    final categories = await dataSource.getCategories();

    expect(request?.method, 'GET');
    expect(request?.path, 'categories');
    expect(categories, hasLength(1));
    expect(categories.single.id, 2);
    expect(categories.single.name, 'Electronics');
  });

  test(
    'requests products by category with pagination and maps the response',
    () async {
      final dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
      RequestOptions? request;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            request = options;
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [
                  {
                    'id': 18,
                    'title': 'Wireless Controller',
                    'slug': 'wireless-controller',
                    'price': 69.5,
                    'description': 'A responsive controller.',
                    'category': {'id': 2, 'name': 'Electronics'},
                    'images': ['https://example.com/controller.jpg'],
                  },
                ],
              ),
            );
          },
        ),
      );

      final apiClient = ApiClient()..dio = dio;
      final dataSource = HomeRemoteDataSourceImplement(apiClient: apiClient);
      final products = await dataSource.getProducts(2, limit: 10, offset: 20);

      expect(request?.method, 'GET');
      expect(request?.path, 'categories/2/products');
      expect(request?.queryParameters, {'limit': 10, 'offset': 20});
      expect(products, hasLength(1));
      expect(products.single.title, 'Wireless Controller');
      expect(products.single.price, 69.5);
      expect(products.single.category.name, 'Electronics');
      expect(products.single.images, ['https://example.com/controller.jpg']);
    },
  );

  test('rejects a non-list API response as invalid data', () async {
    final dio = Dio(BaseOptions(baseUrl: ApiConstant.baseUrl));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'products': []},
            ),
          );
        },
      ),
    );

    final dataSource = HomeRemoteDataSourceImplement(
      apiClient: ApiClient()..dio = dio,
    );

    await expectLater(
      dataSource.getCategories(),
      throwsA(isA<FormatException>()),
    );
  });
}
