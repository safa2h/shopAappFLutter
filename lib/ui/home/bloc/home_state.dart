part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class Homesuccess extends HomeState {
  final List<ProductEntity> latestProducts;
  final List<ProductEntity> popularProducts;
  final List<BannerEntity> banners;

  const Homesuccess(
      {required this.latestProducts,
      required this.popularProducts,
      required this.banners});
}

class HomeError extends HomeState {
  final AppException appException;

  const HomeError(this.appException);

  @override
  List<Object> get props => [appException];
}
