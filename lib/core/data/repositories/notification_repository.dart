import '../mock/mock_data_source.dart';
import '../models/app_notification.dart';

class NotificationRepository {
  NotificationRepository(this._dataSource);

  final MockDataSource _dataSource;

  Future<List<AppNotification>> fetchNotifications() async {
    await _dataSource.ensureLoaded();
    return _dataSource.notifications;
  }

  Future<void> updateNotification(AppNotification notification) async {
    _dataSource.updateNotification(notification);
  }

  Future<void> markAllRead() async {
    final updated = (await fetchNotifications())
        .map((item) => item.copyWith(isRead: true))
        .toList();
    _dataSource.replaceNotifications(updated);
  }

  Future<void> clearPromotions() async {
    final remaining = (await fetchNotifications())
        .where((item) => item.type != 'promo')
        .toList();
    _dataSource.replaceNotifications(remaining);
  }
}
