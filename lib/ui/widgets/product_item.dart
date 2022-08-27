import 'package:flutter/material.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/favorite_manager.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/theme.dart';
import 'package:nike_store/ui/product/details.dart';
import 'package:nike_store/ui/widgets/image_service.dart';

class ProductItem extends StatefulWidget {
  final ProductEntity product;
  final BorderRadius borderRadius;
  final double width;
  final double heght;
  const ProductItem({
    Key? key,
    required this.product,
    required this.borderRadius,
    this.width = 176,
    this.heght = 189,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      borderRadius: widget.borderRadius,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: widget.product,
            ),
          ),
        );
      },
      child: SizedBox(
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: widget.width / widget.heght,
                  child: ImageLoadingService(
                    imageUrl: widget.product.imageUrl,
                    borderRadius: widget.borderRadius,
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
                      child: InkWell(
                          onTap: () {
                            if (!favoriteManager.isFav(widget.product)) {
                              favoriteManager.addToFav(widget.product);
                            } else {
                              favoriteManager.delete(widget.product);
                            }
                            setState(() {});
                          },
                          splashColor: null,
                          child: Icon(
                            favoriteManager.isFav(widget.product)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_outlined,
                            size: 24,
                            color: LightThemeColor.secondryColor,
                          )),
                    )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.product.title,
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
                widget.product.previousPrice.withPriceLable,
                style: themeData.textTheme.caption!
                    .copyWith(decoration: TextDecoration.lineThrough),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(widget.product.price.withPriceLable),
            )
          ],
        ),
      ),
    );
  }
}
