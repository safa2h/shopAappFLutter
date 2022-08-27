import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/data/dataSource/order_data_source.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/payment_reciept.dart';

abstract class IOrderREpository {
  Future<CreateOrderResult> createOrder(CreateOrderParams params);
  Future<PaymentReciptData> getPaymentRecipt(int orderId);
  Future<List<OrderEntity>> getOrders();
}

final orderRepository = OrderRepository(OrderRemoteDataSource(HttpService()));

class OrderRepository implements IOrderREpository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);
  @override
  Future<CreateOrderResult> createOrder(CreateOrderParams params) {
    return dataSource.create(params);
  }

  @override
  Future<PaymentReciptData> getPaymentRecipt(int orderId) {
    return dataSource.getPaymentRecipt(orderId);
  }

  @override
  Future<List<OrderEntity>> getOrders() {
    return dataSource.getOrders();
  }
}
