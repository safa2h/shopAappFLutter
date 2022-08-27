import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/repository/cart_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;
  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonClicked) {
        try {
          emit(ProductAddToCartLoading());
          await cartRepository.add(event.productId);
          await cartRepository.count();
          emit(ProductAddToCartSuccess());
        } catch (e) {
          emit(
              ProductAddToCartError(AppException('خطا در افزودن به سبد خرید')));
        }
      }
    });
  }
}
