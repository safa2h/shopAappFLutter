import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store/common/exception.dart';
import 'package:nike_store/data/banner.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/banner_repository.dart';
import 'package:nike_store/data/repository/product_reopsitory.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IProductRepository productRepository;
  final IBannerRepository bannerRepository;
  HomeBloc({required this.productRepository, required this.bannerRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted) {
        emit(HomeLoading());
        try {
          final banners = await bannerRepository.getBanners();
          final latestProducts =
              await productRepository.getProducts(ProductSort.latest);
          final popularProducts =
              await productRepository.getProducts(ProductSort.popular);
          emit(Homesuccess(
            banners: banners,
            latestProducts: latestProducts,
            popularProducts: popularProducts,
          ));
        } catch (e) {
          emit(HomeError(
              e is AppException ? e : AppException('خطا در دریافت اطلاعات')));
        }
      }
    });
  }
}
