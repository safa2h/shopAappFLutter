part of 'paymet_recipt_bloc.dart';

abstract class PaymetReciptEvent extends Equatable {
  const PaymetReciptEvent();

  @override
  List<Object> get props => [];
}

class PaymentReciptStarted extends PaymetReciptEvent {
  final int orderId;

  const PaymentReciptStarted(this.orderId);
}
