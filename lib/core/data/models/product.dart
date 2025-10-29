import 'dart:convert';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.subcategory,
    required this.price,
    this.salePrice,
    required this.currency,
    required this.stock,
    required this.rating,
    required this.reviewsCount,
    required this.description,
    required this.specs,
    required this.imageUrl,
    required this.imageUrls,
    required this.promoTags,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String brand;
  final String category;
  final String subcategory;
  final double price;
  final double? salePrice;
  final String currency;
  final int stock;
  final double rating;
  final int reviewsCount;
  final String description;
  final Map<String, dynamic> specs;
  final String imageUrl;
  final List<String> imageUrls;
  final List<String> promoTags;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasSale => salePrice != null && salePrice! < price;

  double? get discountPercent => hasSale ? ((1 - (salePrice! / price)) * 100) : null;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      price: (json['price'] as num).toDouble(),
      salePrice: json['sale_price'] == null ? null : (json['sale_price'] as num).toDouble(),
      currency: json['currency'] as String,
      stock: (json['stock'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: (json['reviews_count'] as num).toInt(),
      description: json['description'] as String,
      specs: _specsFromJson(json['specs_json'] as String? ?? '{}'),
      imageUrl: json['image_url'] as String,
      imageUrls: _imageUrlsFromJson(json['image_urls'] as String? ?? ''),
      promoTags: (json['promo_tags'] as List<dynamic>? ?? const <dynamic>[])
          .map((tag) => tag.toString())
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'subcategory': subcategory,
      'price': price,
      'sale_price': salePrice,
      'currency': currency,
      'stock': stock,
      'rating': rating,
      'reviews_count': reviewsCount,
      'description': description,
      'specs_json': json.encode(specs),
      'image_url': imageUrl,
      'image_urls': imageUrls.join('|'),
      'promo_tags': promoTags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

Map<String, dynamic> _specsFromJson(String value) {
  if (value.isEmpty) {
    return <String, dynamic>{};
  }
  return json.decode(value) as Map<String, dynamic>;
}

List<String> _imageUrlsFromJson(String value) =>
    value.split('|').where((element) => element.isNotEmpty).toList();
