part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryErroe extends OrderHistoryState {
  final AppException appException;

  const OrderHistoryErroe(this.appException);
}

class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderEntity> orders;

  const OrderHistorySuccess(this.orders);
}
