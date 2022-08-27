import 'package:nike_store/data/product.dart';

class CartItemEntity {
  final ProductEntity productEntity;
  final int id;
  int count;
  bool deleteButtonLoading = false;
  bool changeCountLoading = false;

  CartItemEntity(this.productEntity, this.id, this.count);

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : productEntity = ProductEntity.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> paseJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => CartItemEntity.fromJson(json)).toList();
  }
}
