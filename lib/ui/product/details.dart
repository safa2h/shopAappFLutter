import 'package:flutter/material.dart';
import 'package:nike_store/common/consts.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/product/comment/comment_list.dart';
import 'package:nike_store/ui/widgets/image_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {}, label: Text('افزودن به سبد خرید')),
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
                  background: ImageLoadingService(imageUrl: product.imageUrl),
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
                            product.title,
                            style: theme.textTheme.headline6,
                          )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                product.previousPrice.withPriceLable,
                                style: theme.textTheme.caption!.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(product.price.withPriceLable),
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
              CommentList(productId: product.id),
            ],
          ),
        ),
      ),
    );
  }
}
