import 'package:flutter/material.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/ui/product/details.dart';
import 'package:nike_store/ui/widgets/image_service.dart';

class ProductItem extends StatelessWidget {
  final ProductEntity product;
  final BorderRadius borderRadius;
  const ProductItem({
    Key? key,
    required this.product,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      borderRadius: borderRadius,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: product,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 176,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 176,
                  height: 189,
                  child: ImageLoadingService(
                    imageUrl: product.imageUrl,
                    borderRadius: borderRadius,
                  ),
                ),
                Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: themeData.colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(18)),
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            size: 24,
                            color: Colors.grey.shade700,
                          )),
                    )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              product.title,
              maxLines: 1,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.clip,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                product.previousPrice.withPriceLable,
                style: themeData.textTheme.caption!
                    .copyWith(decoration: TextDecoration.lineThrough),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(product.price.withPriceLable),
            )
          ],
        ),
      ),
    );
  }
}
