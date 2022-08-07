import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/data/banner.dart';
import 'package:nike_store/data/dataSource/banner_data_source.dart';

abstract class IBannerRepository {
  Future<List<BannerEntity>> getBanners();
}

final bannerRepository = BannerRepository(BannerDataSourceImpl(HttpService()));

class BannerRepository implements IBannerRepository {
  final IBannerDataSource _bannerDataSource;
  BannerRepository(this._bannerDataSource);
  @override
  Future<List<BannerEntity>> getBanners() => _bannerDataSource.getBanners();
}
