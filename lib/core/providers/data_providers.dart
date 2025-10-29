import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock/mock_data_source.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/product_repository.dart';
import 'shared_preferences_provider.dart';

final mockDataSourceProvider = Provider<MockDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MockDataSource(prefs);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(mockDataSourceProvider);
  return ProductRepository(dataSource);
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dataSource = ref.watch(mockDataSourceProvider);
  return NotificationRepository(dataSource);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(mockDataSourceProvider);
  return AuthRepository(dataSource);
});
