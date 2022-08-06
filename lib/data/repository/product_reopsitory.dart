import 'package:nike_store/data/product.dart';

import '../dataSource/product_data_source.dart';

abstract class IProductRepository {
  Future<List<ProductEntity>> getProducts(int sortBy);
  Future<List<ProductEntity>> search(String searchText);
}

final productRepository = ProductRepository(ProductDataSource(httpClient));

class ProductRepository implements IProductRepository {
  final IProductDataSource _productDataSource;

  ProductRepository(this._productDataSource);
  @override
  Future<List<ProductEntity>> getProducts(int sortBy) =>
      _productDataSource.getProducts(sortBy);

  @override
  Future<List<ProductEntity>> search(String searchText) =>
      _productDataSource.search(searchText);
}
