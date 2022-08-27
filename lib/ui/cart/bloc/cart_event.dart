part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartStated extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefresh;

  const CartStated(this.authInfo, {this.isRefresh = false});
}

class CartDeleteButton extends CartEvent {
  final int cartItemId;

  CartDeleteButton(this.cartItemId);
  @override
  // TODO: implement props
  List<Object> get props => [cartItemId];
}

class IncreasCountButtonCLicked extends CartEvent {
  final int cartItemId;

  const IncreasCountButtonCLicked(this.cartItemId);
  @override
  // TODO: implement props
  List<Object> get props => [cartItemId];
}

class DecreasCountButtonCLicked extends CartEvent {
  final int cartItemId;

  const DecreasCountButtonCLicked(this.cartItemId);
  @override
  // TODO: implement props
  List<Object> get props => [cartItemId];
}

class CartAuthChanged extends CartEvent {
  final AuthInfo? authInfo;

  CartAuthChanged(this.authInfo);
}
