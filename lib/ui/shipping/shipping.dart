import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/data/order.dart';
import 'package:nike_store/data/repository/order_repository.dart';
import 'package:nike_store/ui/cart/bloc/price_info.dart';
import 'package:nike_store/ui/payment/payment_gate_way_sceee.dart';
import 'package:nike_store/ui/recipt/recipt.dart';
import 'package:nike_store/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  ShippingScreen(
      {Key? key,
      required this.payablePrice,
      required this.totolaPrice,
      required this.shippingCost})
      : super(key: key);
  final int payablePrice;
  final int totolaPrice;
  final int shippingCost;

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  TextEditingController nameController = TextEditingController(text: 'سعید ');

  TextEditingController lastNameController =
      TextEditingController(text: 'شاهینی');

  TextEditingController mobile = TextEditingController(text: '09910154768');

  TextEditingController postalCode = TextEditingController(text: '4998767543');

  TextEditingController address =
      TextEditingController(text: 'jdsnfjsnd kdflksdlkf esllfdmslm sd');
  StreamSubscription? streamSubscription;
  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحویل گیرنده')),
      body: BlocProvider(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          streamSubscription = bloc.stream.listen((state) {
            if (state is ShippingSuccess) {
              if (state.createOrderResult.bankGetWayUrl.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (contex) => PaymentGetWayScreen(
                        bankGateWay: state.createOrderResult.bankGetWayUrl)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReciptScreen(
                          orderId: state.createOrderResult.orderId,
                        )));
              }
            } else if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.appException.message)));
            }
          });
          return bloc;
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: BlocBuilder<ShippingBloc, ShippingState>(
            builder: (context, state) {
              return state is ShippingLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(label: Text('نام ')),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: lastNameController,
                            decoration: const InputDecoration(
                                label: Text('  نام خانوادگی')),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: mobile,
                            decoration: const InputDecoration(
                                label: Text(' شماره تماس ')),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: postalCode,
                            decoration: InputDecoration(
                                label: const Text('  کد پستی ')),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: address,
                            decoration:
                                const InputDecoration(label: Text('  آٔدرس ')),
                          ),
                          PriceInfo(
                              payablePrice: widget.payablePrice,
                              shippingCost: widget.shippingCost,
                              totalPrice: widget.totolaPrice),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  final params = CreateOrderParams(
                                      nameController.text,
                                      lastNameController.text,
                                      mobile.text,
                                      postalCode.text,
                                      address.text,
                                      PaymentMethod.cashOnDelivery);
                                  BlocProvider.of<ShippingBloc>(context)
                                      .add(ShippingCreateOrder(params));
                                },
                                child: Text('پرداخت در محل'),
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final params = CreateOrderParams(
                                      nameController.text,
                                      lastNameController.text,
                                      mobile.text,
                                      postalCode.text,
                                      address.text,
                                      PaymentMethod.online);
                                  BlocProvider.of<ShippingBloc>(context)
                                      .add(ShippingCreateOrder(params));
                                },
                                child: const Text(' پرداخت اینترنتی '),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
