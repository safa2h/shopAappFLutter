import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/common/http_validator.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/payment_reciept.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentReciptData> getPaymentRecipt(int orderId);
  Future<List<OrderEntity>> getOrders();
}

class OrderRemoteDataSource with HttpValidator implements IOrderDataSource {
  final HttpService httpService;

  OrderRemoteDataSource(this.httpService);
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpService.post('order/submit', {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'mobile': params.phoneNumber,
      'postal_code': params.postalCode,
      'address': params.address,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery',
    });
    responseValidator(response);
    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReciptData> getPaymentRecipt(int orderId) async {
    final response =
        await httpService.getRequest('order/checkout?order_id=$orderId');
    responseValidator(response);

    return PaymentReciptData.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await httpService.getRequest('order/list');
    responseValidator(response);
    return (response.data as List)
        .map((e) => OrderEntity.fromJason(e))
        .toList();
  }
}
