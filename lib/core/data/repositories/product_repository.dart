import 'dart:math';

import 'package:collection/collection.dart';

import '../mock/mock_data_source.dart';
import '../models/brand.dart';
import '../models/product.dart';
import '../models/promotion.dart';

class ProductQuery {
  const ProductQuery({
    this.searchTerm,
    this.category,
    this.brand,
    this.sort,
    this.promoTag,
    this.onlyInStock = false,
    this.offset = 0,
    this.limit = 20,
  });

  final String? searchTerm;
  final String? category;
  final String? brand;
  final ProductSort? sort;
  final String? promoTag;
  final bool onlyInStock;
  final int offset;
  final int limit;
}

enum ProductSort { priceLowHigh, priceHighLow, rating, newest }

class ProductRepository {
  ProductRepository(this._dataSource);

  final MockDataSource _dataSource;

  Future<List<Product>> search(ProductQuery query) async {
    await _dataSource.ensureLoaded();
    Iterable<Product> items = _dataSource.products;
    if (query.searchTerm != null && query.searchTerm!.isNotEmpty) {
      final term = query.searchTerm!.toLowerCase();
      items = items.where((product) =>
          product.name.toLowerCase().contains(term) ||
          product.brand.toLowerCase().contains(term) ||
          product.category.toLowerCase().contains(term));
    }
    if (query.category != null && query.category!.isNotEmpty) {
      items = items.where((product) => product.category == query.category);
    }
    if (query.brand != null && query.brand!.isNotEmpty) {
      items = items.where((product) =>
          product.brand.toLowerCase() == query.brand!.toLowerCase());
    }
    if (query.promoTag != null && query.promoTag!.isNotEmpty) {
      items = items
          .where((product) => product.promoTags.contains(query.promoTag));
    }
    if (query.onlyInStock) {
      items = items.where((product) => product.stock > 0);
    }
    switch (query.sort) {
      case ProductSort.priceLowHigh:
        items = items.sorted((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceHighLow:
        items = items.sorted((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.rating:
        items = items.sorted((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSort.newest:
        items = items.sorted((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case null:
        items = items.sorted((a, b) => a.name.compareTo(b.name));
        break;
    }
    final slice = items.skip(query.offset).take(query.limit).toList();
    return slice;
  }

  Future<Product?> getById(String id) async {
    await _dataSource.ensureLoaded();
    return _dataSource.products.firstWhereOrNull((item) => item.id == id);
  }

  Future<List<Brand>> fetchBrands() async {
    await _dataSource.ensureLoaded();
    return _dataSource.brands;
  }

  Future<List<Promotion>> fetchPromotions() async {
    await _dataSource.ensureLoaded();
    return _dataSource.promotions;
  }

  Future<List<Product>> fetchFeatured({int limit = 12}) async {
    await _dataSource.ensureLoaded();
    final random = Random(13);
    final items = _dataSource.products.toList()..shuffle(random);
    return items.take(limit).toList();
  }

  Future<List<String>> fetchCategories() async {
    await _dataSource.ensureLoaded();
    return _dataSource.products
        .map((product) => product.category)
        .toSet()
        .toList()
      ..sort();
  }
}
