import 'package:flutter/material.dart';
import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/data/cart_item.dart';
import 'package:nike_store/data/add-to_cart_response.dart';
import 'package:nike_store/data/cart_response.dart';
import 'package:nike_store/data/dataSource/cart_data_source.dart';

abstract class ICartRepository {
  Future<AddToCartResponse> add(int productId);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
}

final cartRepository = CartRepository(CartRemoteDataSource(HttpService()));

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static final ValueNotifier<int> cartNotifierCount = ValueNotifier(0);

  CartRepository(this.dataSource);
  @override
  Future<AddToCartResponse> add(int productId) {
    return dataSource.add(productId);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) {
    return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    cartNotifierCount.value = count;

    return count;
  }

  @override
  Future<void> delete(int cartItemId) async {
    await dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() {
    return dataSource.getAll();
  }
}
