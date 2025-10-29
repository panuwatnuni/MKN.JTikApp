import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/brand.dart';
import '../../../core/data/models/product.dart';
import '../../../core/data/repositories/product_repository.dart';
import '../../../core/providers/data_providers.dart';

final brandListProvider = FutureProvider<List<Brand>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchBrands();
});

final brandProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, brandId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.search(
    ProductQuery(brand: brandId, limit: 60, sort: ProductSort.rating),
  );
});
