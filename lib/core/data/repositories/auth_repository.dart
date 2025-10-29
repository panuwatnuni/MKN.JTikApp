import 'dart:math';

import '../mock/mock_data_source.dart';
import '../models/user.dart';

class AuthRepository {
  AuthRepository(this._dataSource);

  final MockDataSource _dataSource;

  Future<User?> currentUser() async {
    await _dataSource.ensureLoaded();
    return _dataSource.currentUser;
  }

  Future<User> login({required String email, required String name, String? phone}) async {
    await _dataSource.ensureLoaded();
    final randomId = Random(email.hashCode ^ name.hashCode).nextInt(999999);
    final user = User(
      id: 'user-$randomId',
      name: name,
      email: email,
      phone: phone,
      addresses: const <String>['123 Bangkok Road, Thailand'],
      paymentMethods: const <String>['JTik Wallet'],
      notificationsEnabled: true,
      twoFactorEnabled: false,
    );
    await _dataSource.upsertUser(user);
    return user;
  }

  Future<void> logout() async {
    await _dataSource.clearUser();
  }

  Future<User> updateUser(User user) async {
    await _dataSource.upsertUser(user);
    return user;
  }
}
