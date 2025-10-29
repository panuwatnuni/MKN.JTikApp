import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/admin_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/new_ticket_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/tracking_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/adaptive_navigation.dart';

void main() {
  runApp(const EServiceApp());
}

class EServiceApp extends StatelessWidget {
  const EServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Service Repair Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(),
      supportedLocales: const [
        Locale('th'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const EServiceHome(),
    );
  }
}

class EServiceHome extends StatefulWidget {
  const EServiceHome({super.key});

  @override
  State<EServiceHome> createState() => _EServiceHomeState();
}

class _EServiceHomeState extends State<EServiceHome> {
  int _index = 0;

  final _pages = const [
    DashboardScreen(),
    NewTicketScreen(),
    TrackingScreen(),
    AdminScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.dashboard_outlined),
        selectedIcon: const Icon(Icons.dashboard),
        label: 'แดชบอร์ด',
      ),
      NavigationDestination(
        icon: const Icon(Icons.note_add_outlined),
        selectedIcon: const Icon(Icons.note_add),
        label: 'แจ้งซ่อม',
      ),
      NavigationDestination(
        icon: const Icon(Icons.track_changes_outlined),
        selectedIcon: const Icon(Icons.track_changes),
        label: 'ติดตามงาน',
      ),
      NavigationDestination(
        icon: const Icon(Icons.handyman_outlined),
        selectedIcon: const Icon(Icons.handyman),
        label: 'ช่าง/แอดมิน',
      ),
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: 'บัญชี',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('JTik Service Center'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'การแจ้งเตือน',
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.lightBlue,
            child: const Icon(Icons.person, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: AdaptiveNavigation(
              selectedIndex: _index,
              onDestinationSelected: (index) {
                setState(() => _index = index);
              },
              destinations: destinations,
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: DecoratedBox(
                key: ValueKey(_index),
                decoration: const BoxDecoration(),
                child: _pages[_index],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _index = 1),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('แจ้งซ่อมใหม่'),
            )
          : null,
    );
  }
}
