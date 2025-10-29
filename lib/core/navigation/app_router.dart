import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/brands/views/brand_detail_view.dart';
import '../../features/brands/views/brand_wall_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/notifications/views/notifications_view.dart';
import '../../features/product/views/product_detail_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/promotions/views/promotion_view.dart';
import '../../features/search/views/search_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _JTikNavigationScaffold(shell: navigationShell),
        branches: [
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeView(),
              ),
              routes: <RouteBase>[
                GoRoute(
                  path: 'search',
                  name: 'search',
                  builder: (context, state) => const SearchView(),
                ),
                GoRoute(
                  path: 'product/:id',
                  name: 'product',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return ProductDetailView(productId: id);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              path: '/brands',
              name: 'brands',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: BrandWallView(),
              ),
              routes: <RouteBase>[
                GoRoute(
                  path: ':id',
                  name: 'brandDetail',
                  builder: (context, state) {
                    final id = Uri.decodeComponent(state.pathParameters['id']!);
                    return BrandDetailView(brandId: id);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              path: '/promotions',
              name: 'promotions',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PromotionHubView(),
              ),
              routes: <RouteBase>[
                GoRoute(
                  path: ':tag',
                  name: 'promotionDetail',
                  builder: (context, state) {
                    final tag = Uri.decodeComponent(state.pathParameters['tag']!);
                    return PromotionDetailView(tag: tag);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              path: '/notifications',
              name: 'notifications',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: NotificationsView(),
              ),
            ),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              path: '/me',
              name: 'profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfileView(),
              ),
            ),
          ]),
        ],
      ),
    ],
  );
});

class _JTikNavigationScaffold extends StatelessWidget {
  const _JTikNavigationScaffold({required this.shell});

  final StatefulNavigationShell shell;

  void _onTabSelected(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: shell,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          backgroundColor: Color(0xFF121212),
          indicatorColor: Color(0xFFC5A253),
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          iconTheme: MaterialStatePropertyAll(IconThemeData(color: Colors.white)),
        ),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          height: 72,
          onDestinationSelected: _onTabSelected,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.tabHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.store_mall_directory_outlined),
              selectedIcon: const Icon(Icons.store),
              label: l10n.tabBrands,
            ),
            NavigationDestination(
              icon: const Icon(Icons.local_fire_department_outlined),
              selectedIcon: const Icon(Icons.local_fire_department),
              label: l10n.tabPromotions,
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_none),
              selectedIcon: const Icon(Icons.notifications_active),
              label: l10n.tabNotifications,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l10n.tabProfile,
            ),
          ],
        ),
      ),
    );
  }
}
