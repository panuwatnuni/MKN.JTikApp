import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/mock/mock_data_source.dart';
import '../../../core/providers/data_providers.dart';

final eserviceSubscriptionProvider = StateNotifierProvider<EserviceSubscriptionNotifier, bool>((ref) {
  final dataSource = ref.watch(mockDataSourceProvider);
  return EserviceSubscriptionNotifier(dataSource);
});

class EserviceSubscriptionNotifier extends StateNotifier<bool> {
  EserviceSubscriptionNotifier(this._dataSource) : super(false) {
    _init();
  }

  final MockDataSource _dataSource;

  Future<void> _init() async {
    await _dataSource.ensureLoaded();
    state = _dataSource.isSubscribedToEservice;
  }

  Future<void> toggleSubscription(bool value) async {
    state = value;
    await _dataSource.toggleEserviceSubscription(value);
  }
}
