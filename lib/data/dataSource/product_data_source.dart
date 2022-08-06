import 'package:dio/dio.dart';
import 'package:nike_store/common/http_validator.dart';

import '../product.dart';

abstract class IProductDataSource {
  Future<List<ProductEntity>> getProducts(int sortBy);
  Future<List<ProductEntity>> search(String searchText);
}

final httpClient = Dio(BaseOptions(
  baseUrl: 'http://expertdevelopers.ir/api/v1/',
));

class ProductDataSource with HttValidator implements IProductDataSource {
  final Dio dio;

  ProductDataSource(this.dio);
  @override
  Future<List<ProductEntity>> getProducts(int sortBy) async {
    final response = await dio.get('product/list?sort=$sortBy');
    responseValidator(response);
    final products = <ProductEntity>[];
    for (var item in (response.data as List)) {
      products.add(ProductEntity.fromJson(item));
    }

    return products;
  }

  @override
  Future<List<ProductEntity>> search(String searchText) async {
    final response = await dio.get('product/search?q=$searchText');
    responseValidator(response);
    final products = <ProductEntity>[];
    for (var item in (response.data as List)) {
      products.add(ProductEntity.fromJson(item));
    }

    return products;
  }
}
