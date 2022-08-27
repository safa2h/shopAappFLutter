import 'package:nike_store/data/cart_item.dart';

class CartResponse {
  final List<CartItemEntity> cartItems;
  int payablePrice;
  int totalPrice;
  int shippingCost;

  CartResponse(
      this.cartItems, this.payablePrice, this.totalPrice, this.shippingCost);

  CartResponse.fromJson(Map<String, dynamic> json)
      : cartItems = CartItemEntity.paseJsonArray(json['cart_items']),
        payablePrice = json['payable_price'],
        totalPrice = json['total_price'],
        shippingCost = json['shipping_cost'];
}
