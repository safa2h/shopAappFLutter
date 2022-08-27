import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/payment_reciept.dart';
import 'package:nike_store/data/repository/order_repository.dart';

part 'paymet_recipt_event.dart';
part 'paymet_recipt_state.dart';

class PaymetReciptBloc extends Bloc<PaymetReciptEvent, PaymetReciptState> {
  final IOrderREpository orderREpository;
  PaymetReciptBloc(this.orderREpository) : super(PaymetReciptLoading()) {
    on<PaymetReciptEvent>((event, emit) async {
      if (event is PaymentReciptStarted) {
        emit(PaymetReciptLoading());
        try {
          final data = await orderREpository.getPaymentRecipt(event.orderId);
          emit(PaymetReciptSuccess(data));
        } catch (e) {
          emit(PaymetReciptError(AppException('error getting data')));
        }
      }
    });
  }
}
