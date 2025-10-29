import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/user.dart';
import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/providers/data_providers.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final repository = ref.read(authRepositoryProvider);
    return repository.currentUser();
  }

  Future<void> login({required String email, required String name, String? phone}) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final user = await repository.login(email: email, name: name, phone: phone);
    state = AsyncData(user);
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncData(null);
  }

  Future<void> updateUser(User user) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final updated = await repository.updateUser(user);
    state = AsyncData(updated);
  }
}
