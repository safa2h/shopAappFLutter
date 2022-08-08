import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/consts.dart';
import 'package:nike_store/common/utils.dart';
import 'package:nike_store/data/banner.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/banner_repository.dart';
import 'package:nike_store/data/repository/product_reopsitory.dart';
import 'package:nike_store/ui/home/bloc/home_bloc.dart';
import 'package:nike_store/ui/widgets/image_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = HomeBloc(
            productRepository: productRepository,
            bannerRepository: bannerRepository);
        bloc.add(HomeStarted());
        return bloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.appException.message),
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<HomeBloc>(context)
                                .add(HomeRefresh());
                          },
                          child: Text('تلاش دوباره'))
                    ],
                  ),
                );
              } else if (state is Homesuccess) {
                return ListView.builder(
                    physics: scrollPhysic,
                    itemCount: 5,
                    itemBuilder: (contex, index) {
                      switch (index) {
                        case 0:
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/img/nike_logo.png',
                                height: 32, width: 80),
                          );
                        case 1:
                          return Container();
                        case 2:
                          return BannerSlider(
                            banners: state.banners,
                          );
                        case 3:
                          return ProductList(
                            products: state.latestProducts,
                            title: 'جدیدترین',
                            tapCallback: () {},
                          );
                        case 4:
                          return ProductList(
                            products: state.popularProducts,
                            title: 'پر بازدیدترین',
                            tapCallback: () {},
                          );
                        default:
                          return Container();
                      }
                    });
              } else {
                throw Exception('Unknown state');
              }
            },
          ),
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<ProductEntity> products;
  final String title;
  final GestureTapCallback tapCallback;
  const ProductList({
    Key? key,
    required this.products,
    required this.title,
    required this.tapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextButton(onPressed: tapCallback, child: Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              physics: scrollPhysic,
              padding: EdgeInsets.only(left: 8, right: 8),
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: ProductItem(
                    product: products[index],
                  ),
                );
              })),
        )
      ],
    );
  }
}

class ProductItem extends StatelessWidget {
  final ProductEntity product;
  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return SizedBox(
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
                  borderRadius: BorderRadius.circular(12),
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
    );
  }
}

class BannerSlider extends StatelessWidget {
  final List<BannerEntity> banners;
  BannerSlider({
    Key? key,
    required this.banners,
  }) : super(key: key);

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
              controller: controller,
              physics: scrollPhysic,
              scrollDirection: Axis.horizontal,
              itemCount: banners.length,
              itemBuilder: (contex, index) {
                return BannerItem(banner: banners[index]);
              }),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: banners.length,
                axisDirection: Axis.horizontal,
                effect: WormEffect(
                    spacing: 8.0,
                    radius: 4.0,
                    dotWidth: 32.0,
                    dotHeight: 4.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.grey.shade400,
                    activeDotColor:
                        themeData.colorScheme.secondary.withOpacity(0.9)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BannerItem extends StatelessWidget {
  const BannerItem({
    Key? key,
    required this.banner,
  }) : super(key: key);

  final BannerEntity banner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: ImageLoadingService(
        imageUrl: banner.image,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
