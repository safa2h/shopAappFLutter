part of 'paymet_recipt_bloc.dart';

abstract class PaymetReciptState extends Equatable {
  const PaymetReciptState();

  @override
  List<Object> get props => [];
}

class PaymetReciptLoading extends PaymetReciptState {}

class PaymetReciptError extends PaymetReciptState {
  final AppException appException;

  const PaymetReciptError(this.appException);
}

class PaymetReciptSuccess extends PaymetReciptState {
  final PaymentReciptData paymentReciptData;

  const PaymetReciptSuccess(this.paymentReciptData);
}
