import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_store/data/product.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const boxName = 'favorites';
  final box = Hive.box<ProductEntity>(boxName);
  ValueListenable<Box<ProductEntity>> get listenable =>
      Hive.box<ProductEntity>(boxName).listenable();
  void addToFav(ProductEntity productEntity) {
    box.put(productEntity.id, productEntity);
  }

  void delete(ProductEntity productEntity) {
    box.delete(productEntity.id);
  }

  List<ProductEntity> get favorties => box.values.toList();
  bool isFav(ProductEntity productEntity) {
    return box.containsKey(productEntity.id);
  }
}
