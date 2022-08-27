import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/common/http_validator.dart';
import 'package:nike_store/data/cart_response.dart';

import '../cart_item.dart';
import '../add-to_cart_response.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(int productId);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
}

class CartRemoteDataSource with HttpValidator implements ICartDataSource {
  final HttpService httpService;

  CartRemoteDataSource(this.httpService);
  @override
  Future<AddToCartResponse> add(int productId) async {
    final response =
        await httpService.post('cart/add', {'product_id': productId});
    responseValidator(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) async {
    final response = await httpService
        .post('cart/changeCount', {'cart_item_id': cartItemId, 'count': count});
    responseValidator(response);

    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpService.getRequest('cart/count');
    responseValidator(response);
    return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId) async {
    final response =
        await httpService.post('cart/remove', {'cart_item_id': cartItemId});
    responseValidator(response);
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpService.getRequest('cart/list');
    responseValidator(response);
    return CartResponse.fromJson(response.data);
  }
}
