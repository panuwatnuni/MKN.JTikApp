import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification.dart';
import '../models/brand.dart';
import '../models/product.dart';
import '../models/promotion.dart';
import '../models/user.dart';

class MockDataSource {
  MockDataSource(this._preferences);

  final SharedPreferences _preferences;

  bool _isLoaded = false;
  final List<Product> _products = <Product>[];
  final List<AppNotification> _notifications = <AppNotification>[];
  late final List<Brand> _brands;
  late final List<Promotion> _promotions;
  User? _user;

  static const String _eserviceKey = 'eservice_waitlist';
  static const String _userKey = 'mock_user';

  Future<void> ensureLoaded() async {
    if (_isLoaded) {
      return;
    }
    final raw = await rootBundle.loadString('assets/data/jtikapp_products_10000.jsonl');
    final lines = raw.split('\n');
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      final map = json.decode(line) as Map<String, dynamic>;
      _products.add(Product.fromJson(map));
    }
    _brands = _buildBrands(_products);
    _promotions = _buildPromotions(_products);
    _notifications.addAll(_seedNotifications());
    final userJson = _preferences.getString(_userKey);
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson) as Map<String, dynamic>);
    }
    _isLoaded = true;
  }

  List<Product> get products => List<Product>.unmodifiable(_products);

  List<Brand> get brands => List<Brand>.unmodifiable(_brands);

  List<Promotion> get promotions => List<Promotion>.unmodifiable(_promotions);

  List<AppNotification> get notifications => List<AppNotification>.unmodifiable(_notifications);

  bool get isSubscribedToEservice => _preferences.getBool(_eserviceKey) ?? false;

  Future<void> toggleEserviceSubscription(bool value) async {
    await _preferences.setBool(_eserviceKey, value);
  }

  Future<void> upsertUser(User user) async {
    _user = user;
    await _preferences.setString(_userKey, json.encode(user.toJson()));
  }

  Future<void> clearUser() async {
    _user = null;
    await _preferences.remove(_userKey);
  }

  User? get currentUser => _user;

  void updateNotification(AppNotification notification) {
    final index = _notifications.indexWhere((element) => element.id == notification.id);
    if (index != -1) {
      _notifications[index] = notification;
    }
  }

  void replaceNotifications(List<AppNotification> items) {
    _notifications
      ..clear()
      ..addAll(items);
  }

  List<Brand> _buildBrands(List<Product> items) {
    final grouped = groupBy<Product, String>(items, (product) => product.brand);
    final brands = grouped.entries.map((entry) {
      final categories = entry.value.map((e) => e.category).toSet().toList()..sort();
      return Brand(
        id: entry.key.toLowerCase(),
        name: entry.key,
        description: 'Discover ${entry.key} exclusives crafted for you.',
        heroImage: entry.value.first.imageUrl,
        productCount: entry.value.length,
        categories: categories,
      );
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return brands;
  }

  List<Promotion> _buildPromotions(List<Product> items) {
    final Map<String, int> counts = <String, int>{};
    for (final product in items) {
      for (final tag in product.promoTags) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }
    final promotions = counts.entries.map((entry) {
      final tag = entry.key;
      return Promotion(
        id: tag.toLowerCase().replaceAll(' ', '-'),
        title: tag,
        description: 'Explore $tag deals across the catalog.',
        tags: <String>[tag],
      );
    }).toList()
      ..sort((a, b) => b.title.compareTo(a.title));
    return promotions;
  }

  List<AppNotification> _seedNotifications() {
    final now = DateTime.now();
    return <AppNotification>[
      AppNotification(
        id: 'n_001',
        type: 'order',
        title: 'Order Shipped',
        body: 'Your Aurora Signature order is on the way.',
        createdAt: now.subtract(const Duration(hours: 3)),
        action: const NotificationAction(
          label: 'Track order',
          type: 'deeplink',
          target: '/orders/aurora-001',
        ),
      ),
      AppNotification(
        id: 'n_002',
        type: 'promo',
        title: 'Flash Sale Ends Soon',
        body: 'Extra 10% off for Aurora brand.',
        createdAt: now.subtract(const Duration(hours: 5)),
        action: const NotificationAction(
          label: 'Shop now',
          type: 'deeplink',
          target: '/brands/aurora?promo=flash-sale',
        ),
      ),
      AppNotification(
        id: 'n_003',
        type: 'system',
        title: 'New security update',
        body: 'Enable 2FA for extra protection.',
        createdAt: now.subtract(const Duration(days: 1)),
        action: const NotificationAction(
          label: 'Enable 2FA',
          type: 'deeplink',
          target: '/me/security',
        ),
      ),
      AppNotification(
        id: 'n_004',
        type: 'service',
        title: 'E-Service waitlist',
        body: 'We will notify you once E-Service launches.',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ]
      ..addAll(List<AppNotification>.generate(26, (index) {
        final idx = index + 5;
        return AppNotification(
          id: 'n_${idx.toString().padLeft(3, '0')}',
          type: ['order', 'promo', 'system', 'service'][idx % 4],
          title: 'Insight ${idx.toString().padLeft(2, '0')}',
          body: 'Curated update ${idx.toString().padLeft(2, '0')} for your account.',
          createdAt: now.subtract(Duration(hours: 6 + idx)),
          action: idx.isEven
              ? NotificationAction(
                  label: idx % 3 == 0 ? 'Apply coupon' : 'Remind later',
                  type: 'deeplink',
                  target: idx % 3 == 0 ? '/promotions/coupon-$idx' : '/notifications/$idx',
                )
              : null,
        );
      }));
  }
}
