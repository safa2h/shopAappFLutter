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
import 'package:nike_store/ui/list/list_screen.dart';
import 'package:nike_store/ui/widgets/error_widget.dart';
import 'package:nike_store/ui/widgets/image_service.dart';
import 'package:nike_store/ui/widgets/product_item.dart';
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
                return ErrorWidgetCustom(
                  errorMessage: state.appException.message,
                  tapCallback: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
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
                            tapCallback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (contex) =>
                                      ListScreen(sort: ProductSort.latest)));
                            },
                          );
                        case 4:
                          return ProductList(
                            products: state.popularProducts,
                            title: 'پر بازدیدترین',
                            tapCallback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (contex) =>
                                      ListScreen(sort: ProductSort.popular)));
                            },
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
              TextButton(
                  onPressed: tapCallback, child: const Text('مشاهده همه'))
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
              physics: scrollPhysic,
              padding: const EdgeInsets.only(left: 8, right: 8),
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: ProductItem(
                    product: products[index],
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              })),
        )
      ],
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
