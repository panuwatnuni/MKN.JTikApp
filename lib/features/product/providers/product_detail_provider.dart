import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/product.dart';
import '../../../core/data/repositories/product_repository.dart';
import '../../../core/providers/data_providers.dart';

final productDetailProvider = FutureProvider.family<Product?, String>((ref, id) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getById(id);
});
