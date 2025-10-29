class Brand {
  const Brand({
    required this.id,
    required this.name,
    this.description,
    this.heroImage,
    this.productCount = 0,
    this.categories = const <String>[],
  });

  final String id;
  final String name;
  final String? description;
  final String? heroImage;
  final int productCount;
  final List<String> categories;

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      heroImage: json['heroImage'] as String?,
      productCount: json['productCount'] as int? ?? 0,
      categories: (json['categories'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'heroImage': heroImage,
        'productCount': productCount,
        'categories': categories,
      };
}
