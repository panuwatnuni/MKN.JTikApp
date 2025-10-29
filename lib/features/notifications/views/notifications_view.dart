import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/notification_providers.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabNotifications),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: l10n.markAllRead,
            onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: l10n.clearPromotions,
            onPressed: () => ref.read(notificationsProvider.notifier).clearPromotions(),
          ),
        ],
      ),
      body: notifications.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(l10n.emptyState, style: Theme.of(context).textTheme.titleMedium),
            );
          }
          final grouped = groupBy(items, (item) => item.type);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: grouped.entries.map((entry) {
              final type = entry.key;
              final values = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: const Color(0xFFC5A253)),
                  ),
                  const SizedBox(height: 8),
                  ...values.map(
                    (notification) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Dismissible(
                        key: ValueKey(notification.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => ref
                            .read(notificationsProvider.notifier)
                            .markRead(notification.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: notification.isRead
                                  ? Colors.white12
                                  : const Color(0xFFC5A253),
                            ),
                          ),
                          tileColor: const Color(0xFF161616),
                          leading: Icon(
                            _iconForType(type),
                            color: notification.isRead
                                ? Colors.white54
                                : const Color(0xFFC5A253),
                          ),
                          title: Text(notification.title),
                          subtitle: Text(notification.body),
                          trailing: notification.action != null
                              ? TextButton(
                                  onPressed: () {
                                    ref.read(notificationsProvider.notifier).markRead(notification.id);
                                    _handleAction(context, notification.action!.target);
                                  },
                                  child: Text(notification.action!.label),
                                )
                              : null,
                          onTap: () => ref
                              .read(notificationsProvider.notifier)
                              .markRead(notification.id),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'order':
        return Icons.local_shipping;
      case 'promo':
        return Icons.local_fire_department;
      case 'system':
        return Icons.security;
      case 'service':
        return Icons.headset_mic;
      default:
        return Icons.notifications;
    }
  }

  void _handleAction(BuildContext context, String target) {
    if (target.startsWith('/brands')) {
      context.go(target);
    } else if (target.startsWith('/promotions')) {
      context.go(target);
    } else if (target.startsWith('/me')) {
      context.go('/me');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Action: $target')),
      );
    }
  }
}
