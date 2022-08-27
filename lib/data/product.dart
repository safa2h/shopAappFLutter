import 'package:hive_flutter/adapters.dart';
part 'product.g.dart';

@HiveType(typeId: 0)
class ProductEntity extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int price;
  @HiveField(3)
  final int desicount;
  @HiveField(4)
  final int previousPrice;
  @HiveField(5)
  final String imageUrl;

  ProductEntity(this.id, this.title, this.price, this.desicount,
      this.previousPrice, this.imageUrl);

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        price = json['price'],
        desicount = json['desicount'] ?? 0,
        previousPrice = json['previous_price'] ?? json['price'],
        imageUrl = json['image'];
}

class ProductSort {
  static const int latest = 0;
  static const int popular = 1;
  static const int priceHightoLow = 2;
  static const int priceLowToHigh = 3;

  static List<String> names = [
    'جدیدترین',
    'پر بازدیدترین',
    'زیاد به کم',
    'کم به زیاد'
  ];
}
