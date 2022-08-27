import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/repository/order_repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderREpository orderRepository;
  ShippingBloc(this.orderRepository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateOrder) {
        emit(ShippingLoading());
        try {
          final response = await orderRepository.createOrder(event.params);
          emit(ShippingSuccess(response));
        } catch (e) {
          emit(ShippingError(AppException(e.toString())));
        }
      }
    });
  }
}
