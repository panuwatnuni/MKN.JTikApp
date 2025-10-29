import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/product.dart';
import '../../../core/data/repositories/product_repository.dart';
import '../../../core/providers/data_providers.dart';

final homeFeaturedProductsProvider = FutureProvider<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchFeatured(limit: 16);
});

final flashSaleProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final all = await repository.search(
    const ProductQuery(limit: 40, promoTag: 'Flash Sale'),
  );
  return all;
});

final newArrivalsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.search(
    const ProductQuery(limit: 12, sort: ProductSort.newest),
  );
});

final mostReviewedProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final items = await repository.search(
    const ProductQuery(limit: 12, sort: ProductSort.rating),
  );
  return items;
});

final categoryListProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchCategories();
});
