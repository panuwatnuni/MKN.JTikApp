import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/app_notification.dart';
import '../../../core/data/repositories/notification_repository.dart';
import '../../../core/providers/data_providers.dart';

final notificationsProvider =
    AsyncNotifierProvider<NotificationsController, List<AppNotification>>(
  NotificationsController.new,
);

class NotificationsController extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final repository = ref.read(notificationRepositoryProvider);
    final items = await repository.fetchNotifications();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> markRead(String id) async {
    final repository = ref.read(notificationRepositoryProvider);
    final current = state.value ?? await repository.fetchNotifications();
    final updated = current
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList();
    state = AsyncData(updated);
    await repository.updateNotification(
      updated.firstWhere((element) => element.id == id),
    );
  }

  Future<void> markAllRead() async {
    state = const AsyncLoading();
    final repository = ref.read(notificationRepositoryProvider);
    await repository.markAllRead();
    state = AsyncData(await repository.fetchNotifications());
  }

  Future<void> clearPromotions() async {
    state = const AsyncLoading();
    final repository = ref.read(notificationRepositoryProvider);
    await repository.clearPromotions();
    state = AsyncData(await repository.fetchNotifications());
  }
}
