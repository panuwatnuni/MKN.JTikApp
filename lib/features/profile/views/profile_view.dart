import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../auth/providers/auth_controller.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context);
    return authState.when(
      data: (user) {
        if (user == null) {
          return _UnauthenticatedProfile(onLogin: () => _showLoginSheet(context, ref));
        }
        return _AuthenticatedProfile(user: user, onLogout: () => ref.read(authControllerProvider.notifier).logout());
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  Future<void> _showLoginSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.loginCta, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).login(
                        email: emailController.text,
                        name: nameController.text,
                        phone: phoneController.text,
                      );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  backgroundColor: const Color(0xFFC5A253),
                  foregroundColor: Colors.black,
                ),
                child: Text(l10n.loginCta),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UnauthenticatedProfile extends StatelessWidget {
  const _UnauthenticatedProfile({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabProfile), backgroundColor: Colors.transparent),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 72, color: Color(0xFFC5A253)),
            const SizedBox(height: 16),
            Text(l10n.loginCta, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                backgroundColor: const Color(0xFFC5A253),
                foregroundColor: Colors.black,
              ),
              child: Text(l10n.loginCta),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthenticatedProfile extends StatelessWidget {
  const _AuthenticatedProfile({required this.user, required this.onLogout});

  final User user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabProfile),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: onLogout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFC5A253),
              child: Icon(Icons.person, color: Colors.black),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Text(user.phone ?? ''),
          ),
          const SizedBox(height: 16),
          _ProfileSection(
            title: l10n.addressBook,
            children: user.addresses
                .map((address) => ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(address),
                    ))
                .toList(),
          ),
          _ProfileSection(
            title: l10n.orders,
            children: const [
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: Text('No recent orders'),
              ),
            ],
          ),
          _ProfileSection(
            title: l10n.paymentMethods,
            children: user.paymentMethods
                .map((method) => ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: Text(method),
                    ))
                .toList(),
          ),
          _ProfileSection(
            title: l10n.notificationSettings,
            children: [
              SwitchListTile(
                value: user.notificationsEnabled,
                onChanged: (_) {},
                title: Text(l10n.tabNotifications),
              ),
            ],
          ),
          _ProfileSection(
            title: l10n.profileSecurity,
            children: [
              SwitchListTile(
                value: user.twoFactorEnabled,
                onChanged: (_) {},
                title: Text(l10n.twoFactor),
              ),
              ListTile(
                leading: const Icon(Icons.lock_reset),
                title: Text(l10n.changePassword),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 24, color: Colors.white12),
            ...children,
          ],
        ),
      ),
    );
  }
}
