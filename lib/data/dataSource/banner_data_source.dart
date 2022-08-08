import 'package:nike_store/common/http_service.dart';
import 'package:nike_store/common/http_validator.dart';
import 'package:nike_store/data/banner.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getBanners();
}

class BannerDataSourceImpl with HttpValidator implements IBannerDataSource {
  final HttpService _httpService;

  BannerDataSourceImpl(this._httpService);
  @override
  Future<List<BannerEntity>> getBanners() async {
    final response = await _httpService.getRequest('banner/slider');
    responseValidator(response);
    final banners = <BannerEntity>[];
    for (var item in (response.data as List)) {
      banners.add(BannerEntity.fromJson(item));
    }
    return banners;
  }
}
