import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/consts.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/product/bloc/product_bloc.dart';
import 'package:nike_store/ui/product/comment/comment_list.dart';
import 'package:nike_store/ui/widgets/error_widget.dart';
import 'package:nike_store/ui/widgets/image_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({Key? key, required this.product}) : super(key: key);
  final ProductEntity product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  StreamSubscription? subscription;

  @override
  void dispose() {
    // TODO: implement dispose
    subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('با موفقیت به سبد خرید اضافه شد')));
            } else if (state is ProductAddToCartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطا در اضافه کردن به سبد خرید')));
            }
          });
          return bloc;
        },
        child: SafeArea(
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(CartAddButtonClicked(widget.product.id));
                    },
                    label: state is ProductAddToCartLoading
                        ? CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : Text('افزودن به سبد خرید'));
              },
            ),
            body: CustomScrollView(
              physics: scrollPhysic,
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.grey.shade200,
                  pinned: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ],
                  foregroundColor: LightThemeColor.primaryTextColor,
                  expandedHeight: MediaQuery.of(context).size.width * 0.7,
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        ImageLoadingService(imageUrl: widget.product.imageUrl),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              widget.product.title,
                              style: theme.textTheme.headline6,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLable,
                                  style: theme.textTheme.caption!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(widget.product.price.withPriceLable),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد.',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('نظرات کاربران',
                                  style: theme.textTheme.subtitle1),
                              TextButton(
                                  onPressed: () {}, child: Text('نظر بدهید')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
