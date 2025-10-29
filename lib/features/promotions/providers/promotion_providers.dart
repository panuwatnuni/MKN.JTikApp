import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/product.dart';
import '../../../core/data/models/promotion.dart';
import '../../../core/data/repositories/product_repository.dart';
import '../../../core/providers/data_providers.dart';

final promotionListProvider = FutureProvider<List<Promotion>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchPromotions();
});

final promotionProductsProvider = FutureProvider.family<List<Product>, String>(
    (ref, promoTag) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.search(
    ProductQuery(promoTag: promoTag, limit: 60, sort: ProductSort.priceLowHigh),
  );
});
