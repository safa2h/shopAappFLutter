class BannerEntity {
  final int id;
  final String image;

  BannerEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'];
}
