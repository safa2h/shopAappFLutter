import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/auth_info.dart';
import 'package:nike_store/data/cart_response.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/ui/auth/atuh.dart';
import 'package:nike_store/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_store/ui/cart/bloc/price_info.dart';
import 'package:nike_store/ui/shipping/shipping.dart';
import 'package:nike_store/ui/widgets/emty_state.dart';
import 'package:nike_store/ui/widgets/error_widget.dart';
import 'package:nike_store/ui/widgets/image_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? _cartBloc;
  final RefreshController refreshController = RefreshController();
  StreamSubscription? streamSubscription;
  bool isCartSuccess = false;
  @override
  void initState() {
    // TODO: implement initState
    AuthRepository.authInfoNotifire.addListener(authNotifireListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    AuthRepository.authInfoNotifire.removeListener(authNotifireListener);
    _cartBloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  void authNotifireListener() {
    _cartBloc?.add(CartAuthChanged(AuthRepository.authInfoNotifire.value));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('سبد خرید'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: isCartSuccess,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 48,
          child: FloatingActionButton.extended(
              onPressed: () {
                final state = _cartBloc?.state;
                if (state is CartSuccess) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShippingScreen(
                            payablePrice: state.cartResponse.payablePrice,
                            totolaPrice: state.cartResponse.totalPrice,
                            shippingCost: state.cartResponse.shippingCost,
                          )));
                }
              },
              label: Text('پرداخت')),
        ),
      ),
      body: BlocProvider<CartBloc>(
        create: (context) {
          _cartBloc = CartBloc(cartRepository);

          streamSubscription = _cartBloc!.stream.listen((state) {
            if (state is CartSuccess) {
              setState(() {
                isCartSuccess = true;
              });
            } else {
              isCartSuccess = false;
            }
            if (refreshController.isRefresh) {
              if (state is CartSuccess) {
                refreshController.refreshCompleted();
              }
            } else if (state is CartError) {
              refreshController.refreshFailed();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.appException.message),
                ),
              );
            }
          });
          _cartBloc!.add(CartStated(AuthRepository.authInfoNotifire.value));

          return _cartBloc!;
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartError) {
              return ErrorWidgetCustom(
                  errorMessage: state.appException.message,
                  tapCallback: () {
                    BlocProvider.of<CartBloc>(context)
                        .add(CartStated(AuthRepository.authInfoNotifire.value));
                  });
            } else if (state is CartEmpty) {
              return Column(
                children: [
                  SizedBox(
                    child: EmptyState(
                        message: 'سبد خرید شما خالی می باشد',
                        image: SvgPicture.asset(
                          'assets/svgs/empty_cart.svg',
                          width: 200,
                          height: 200,
                        )),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<CartBloc>(context).add(
                            CartStated(AuthRepository.authInfoNotifire.value));
                      },
                      child: Text('تلاش دوباره'))
                ],
              );
            } else if (state is CartSuccess) {
              return CartList(
                refreshController: refreshController,
                themeData: themeData,
                cartResponse: state.cartResponse,
              );
            } else if (state is CartAuthReq) {
              return EmptyState(
                message: 'لطفا وارد حساب کاربری شوید',
                image: SvgPicture.asset(
                  'assets/svgs/auth_required.svg',
                  width: 200,
                  height: 200,
                ),
                callToaction: ElevatedButton(
                  child: Text('ورود'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => AuthScreen()));
                  },
                ),
              );
            } else {
              throw Exception('Unknown state');
            }
          },
        ),
      ),

      //  ValueListenableBuilder<AuthInfo?>(
      //   valueListenable: AuthRepository.authInfoNotifire,
      //   builder: (context, value, child) {
      //     return Center(
      //       child: (value != null && value.accessToen.isNotEmpty)
      //           ? Column(
      //               children: [
      //                 Text('خوش آمدید'),
      //                 ElevatedButton(
      //                     onPressed: () {
      //                       authRepository.signOut();
      //                     },
      //                     child: Text('خروج'))
      //               ],
      //             )
      //           : Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Text('لطفا وارد حساب کاربری خود شوید'),
      //                 ElevatedButton(
      //                     onPressed: () {
      //                       Navigator.of(context, rootNavigator: true).push(
      //                           MaterialPageRoute(
      //                               builder: (context) => AuthScreen()));
      //                     },
      //                     child: Text('ورود'))
      //               ],
      //             ),
      //     );
      //   },
      // ),
    );
  }
}

class CartList extends StatelessWidget {
  const CartList({
    Key? key,
    required this.themeData,
    required this.cartResponse,
    required this.refreshController,
  }) : super(key: key);

  final ThemeData themeData;
  final CartResponse cartResponse;
  final RefreshController refreshController;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      header: const ClassicHeader(
        completeText: 'با موفقیت به روز رسانی شد',
        refreshingText: 'در حال بارگزاری...',
        failedText: 'بارگزاری نشد',
        idleText: 'برای بروزرسانی پایین بکشید',
        completeIcon: Icon(
          CupertinoIcons.check_mark,
          color: Colors.grey,
        ),
      ),
      onRefresh: (() {
        BlocProvider.of<CartBloc>(context).add(
            CartStated(AuthRepository.authInfoNotifire.value, isRefresh: true));
      }),
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 80),
        itemCount: cartResponse.cartItems.length + 1,
        itemBuilder: (context, index) {
          if (index < cartResponse.cartItems.length) {
            final cartItem = cartResponse.cartItems[index];
            return Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: themeData.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ImageLoadingService(
                            imageUrl: cartItem.productEntity.imageUrl,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          cartItem.productEntity.title,
                          style: themeData.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('تعداد'),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(CupertinoIcons.plus_rectangle),
                                onPressed: () {
                                  BlocProvider.of<CartBloc>(context).add(
                                      IncreasCountButtonCLicked(cartItem.id));
                                },
                              ),
                              cartItem.changeCountLoading
                                  ? CupertinoActivityIndicator()
                                  : Text(
                                      cartItem.count.toString(),
                                      style: themeData.textTheme.headline6,
                                    ),
                              IconButton(
                                icon:
                                    const Icon(CupertinoIcons.minus_rectangle),
                                onPressed: () {
                                  BlocProvider.of<CartBloc>(context).add(
                                      DecreasCountButtonCLicked(cartItem.id));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cartItem
                                  .productEntity.previousPrice.withPriceLable,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              cartItem.productEntity.price.withPriceLable,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 3,
                  ),
                  cartItem.deleteButtonLoading
                      ? CupertinoActivityIndicator()
                      : TextButton(
                          onPressed: () {
                            BlocProvider.of<CartBloc>(context)
                                .add(CartDeleteButton(cartItem.id));
                          },
                          child: Text('حذف از سبد خرید'))
                ],
              ),
            );
          } else {
            return PriceInfo(
              payablePrice: cartResponse.payablePrice,
              totalPrice: cartResponse.totalPrice,
              shippingCost: cartResponse.shippingCost,
            );
          }
        },
      ),
    );
  }
}
