import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/repository/order_repository.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final IOrderREpository orderREpository;
  OrderHistoryBloc(this.orderREpository) : super(OrderHistoryLoading()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderStarted) {
        emit(OrderHistoryLoading());

        try {
          final data = await orderREpository.getOrders();
          emit(OrderHistorySuccess(data));
        } catch (e) {
          emit(OrderHistoryErroe(AppException(e.toString())));
        }
      }
    });
  }
}
