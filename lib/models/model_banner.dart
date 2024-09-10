class BannerModel {
  final String? title;
  final String? description;
  final String? image;

  const BannerModel({this.title, this.description, this.image});

  BannerModel copyWith({
    String? title,
    String? description,
    String? image,
  }) {
    return BannerModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'image': image,
      };

  static BannerModel fromJson(Map<String, dynamic> json) => BannerModel(
        title: json['title'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
      );

  @override
  String toString() =>
      'BannerModel(title: $title, description: $description, image: $image)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          image == other.image;

  @override
  int get hashCode => Object.hash(runtimeType, title, description, image);
}
