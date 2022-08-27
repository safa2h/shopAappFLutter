import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/repository/order_repository.dart';
import 'package:nike_store/ui/recipt/bloc/paymet_recipt_bloc.dart';

class ReciptScreen extends StatelessWidget {
  const ReciptScreen({Key? key, required this.orderId}) : super(key: key);
  final int orderId;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = PaymetReciptBloc(orderRepository);
          bloc.add(PaymentReciptStarted(orderId));
          return bloc;
        },
        child: BlocBuilder<PaymetReciptBloc, PaymetReciptState>(
          builder: (context, state) {
            if (state is PaymetReciptLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PaymetReciptSuccess) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: themeData.dividerColor, width: 1)),
                    child: Column(
                      children: [
                        Text(
                          state.paymentReciptData.perchaseSuccess == false
                              ? 'پراخت در محل'
                              : 'پرداخت موفق',
                          style: themeData.textTheme.headline6!
                              .copyWith(color: themeData.colorScheme.primary),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'وضغیت سفارش:',
                              style: themeData.textTheme.bodyText1!,
                            ),
                            SizedBox(width: 8),
                            Text(
                              state.paymentReciptData.paymentStatus,
                              style: themeData.textTheme.bodyText1!.copyWith(
                                  color: themeData.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' مبلغ: ',
                              style: themeData.textTheme.bodyText1!,
                            ),
                            SizedBox(width: 8),
                            Text(
                              state.paymentReciptData.payablePrice
                                  .withPriceLable,
                              style: themeData.textTheme.bodyText1!.copyWith(
                                  color: themeData.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      );
                    },
                    child: Text('بازگشت به صفحه اصلی'),
                  )
                ],
              );
            } else if (state is PaymetReciptError) {
              return Center(
                child: Text('error'),
              );
            } else {
              throw Exception('state not valid');
            }
          },
        ),
      ),
    );
  }
}
