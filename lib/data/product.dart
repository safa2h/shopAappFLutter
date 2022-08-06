class ProductEntity {
  ProductEntity(
      {required this.desicount,
      required this.previousPrice,
      required this.id,
      required this.title,
      required this.price,
      required this.imageUrl});
  final int id;
  final String title;
  final int price;
  final int desicount;
  final int previousPrice;
  final String imageUrl;

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
}
