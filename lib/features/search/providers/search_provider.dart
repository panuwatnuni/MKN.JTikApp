import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/product.dart';
import '../../../core/data/repositories/product_repository.dart';
import '../../../core/providers/data_providers.dart';

final searchHistoryProvider = StateProvider<List<String>>((ref) => <String>[]);

final searchResultsProvider =
    AsyncNotifierProvider<SearchController, List<Product>>(
  SearchController.new,
);

class SearchController extends AsyncNotifier<List<Product>> {
  String _query = '';

  @override
  Future<List<Product>> build() async {
    return <Product>[];
  }

  Future<void> submit(String query) async {
    _query = query;
    if (query.isEmpty) {
      state = const AsyncData(<Product>[]);
      return;
    }
    state = const AsyncLoading();
    final repository = ref.read(productRepositoryProvider);
    final results = await repository.search(
      ProductQuery(searchTerm: query, limit: 40),
    );
    final history = ref.read(searchHistoryProvider.notifier);
    final current = [...history.state];
    if (query.isNotEmpty) {
      current.remove(query);
      current.insert(0, query);
      history.state = current.take(8).toList();
    }
    state = AsyncData(results);
  }

  String get query => _query;
}
