import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_store/data/repository/order_repository.dart';
import 'package:nike_store/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_store/ui/widgets/emty_state.dart';
import 'package:nike_store/ui/widgets/error_widget.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('سوابق سفارش')),
      body: BlocProvider(
        create: (context) {
          final bloc = OrderHistoryBloc(orderRepository);
          bloc.add(OrderStarted());
          return bloc;
        },
        child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return EmptyState(
                    message: 'emty',
                    image: SvgPicture.asset('assets/svgs/no_data.svg'));
              } else {
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).dividerColor)),
                        child: Text(order.id.toString()),
                      );
                    });
              }
            } else if (state is OrderHistoryLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OrderHistoryErroe) {
              return ErrorWidgetCustom(
                  errorMessage: 'نا موفق',
                  tapCallback: () {
                    BlocProvider.of<OrderHistoryBloc>(context)
                        .add(OrderStarted());
                  });
            } else {
              throw Exception('state not valid');
            }
          },
        ),
      ),
    );
  }
}
