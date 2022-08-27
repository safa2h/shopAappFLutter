import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/auth_info.dart';
import 'package:nike_store/data/cart_response.dart';
import 'package:nike_store/data/repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;
  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStated) {
        if (event.authInfo == null || event.authInfo!.accessToen.isEmpty) {
          emit(CartAuthReq());
        } else {
          if (!event.isRefresh) {
            emit(CartLoading());
          }

          try {
            final cartResponse = await cartRepository.getAll();
            if (cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(CartSuccess(cartResponse));
            }
          } on AppException catch (e) {
            emit(CartError(e));
          }
        }
      } else if (event is CartAuthChanged) {
        if (event.authInfo == null || event.authInfo!.accessToen.isEmpty) {
          emit(CartAuthReq());
        } else {
          if (state is CartAuthReq) {
            emit(CartLoading());

            try {
              final cartResponse = await cartRepository.getAll();
              emit(CartSuccess(cartResponse));
            } on AppException catch (e) {
              emit(CartError(e));
            }
          }
        }
      } else if (event is CartDeleteButton) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartItem = successState.cartResponse.cartItems
                .firstWhere((element) => element.id == event.cartItemId);
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              cartItem.deleteButtonLoading = true;
              emit(CartSuccess(successState.cartResponse));
            }
          }

          await cartRepository.delete(event.cartItemId);
          await cartRepository.count();

          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartResponse.cartItems
                .removeWhere((element) => element.id == event.cartItemId);

            emit(calculatePrice(successState.cartResponse));
            if (successState.cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            }
          }
        } catch (e) {
          emit(CartError(AppException('error when deeltenig')));
        }
      } else if (event is IncreasCountButtonCLicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartIIndex = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == event.cartItemId);

            successState.cartResponse.cartItems[cartIIndex].changeCountLoading =
                true;
            emit(CartSuccess(successState.cartResponse));
            final newCount =
                successState.cartResponse.cartItems[cartIIndex].count + 1;
            if (newCount > 5) {
              emit(CartError(
                  AppException('بیشتر از ۵ محصول نمیتوانید اضافه کنید')));
            }
            await cartRepository.changeCount(event.cartItemId, newCount);
            await cartRepository.count();

            successState.cartResponse.cartItems
                .firstWhere((element) => element.id == event.cartItemId)
              ..count = newCount
              ..changeCountLoading = false;

            emit(calculatePrice(successState.cartResponse));
          }
        } catch (e) {
          emit(CartError(AppException('error when deeltenig')));
        }
      } else if (event is DecreasCountButtonCLicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartIIndex = successState.cartResponse.cartItems
                .indexWhere((element) => element.id == event.cartItemId);

            successState.cartResponse.cartItems[cartIIndex].changeCountLoading =
                true;
            emit(CartSuccess(successState.cartResponse));
            final newCount =
                successState.cartResponse.cartItems[cartIIndex].count - 1;
            if (newCount < 1) {
              emit(CartError(
                  AppException('آیتم  نمی تواند کمتر از یک عدد باشد')));
            } else {
              await cartRepository.changeCount(event.cartItemId, newCount);
              await cartRepository.count();
            }

            successState.cartResponse.cartItems
                .firstWhere((element) => element.id == event.cartItemId)
              ..count = newCount < 1 ? 1 : newCount
              ..changeCountLoading = false;

            emit(calculatePrice(successState.cartResponse));
          }
        } catch (e) {
          emit(CartError(AppException('error when deeltenig')));
        }
      }
    });
  }

  CartSuccess calculatePrice(CartResponse cartResponse) {
    int totalPrice = 0;
    int shipingCost = 0;
    int payablePrice = 0;
    cartResponse.cartItems.forEach((cartItem) {
      totalPrice += cartItem.productEntity.previousPrice * cartItem.count;
      payablePrice += cartItem.productEntity.price * cartItem.count;
    });
    shipingCost = payablePrice > 250000 ? 0 : 30000;
    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shipingCost;
    return CartSuccess(cartResponse);
  }
}
