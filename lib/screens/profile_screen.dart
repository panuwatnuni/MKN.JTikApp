import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('บัญชีผู้ใช้', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isWide ? 2 : 0,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  child: const Icon(Icons.person, size: 36, color: AppColors.primaryBlue),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nattapong S.', style: theme.textTheme.titleLarge),
                                    const SizedBox(height: 4),
                                    Text('Facility Coordinator', style: theme.textTheme.bodyMedium),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _ProfileTile(label: 'อีเมล', value: 'nattapong.s@example.com'),
                            _ProfileTile(label: 'เบอร์โทร', value: '02-123-4567 ต่อ 204'),
                            _ProfileTile(label: 'หน่วยงาน', value: 'แผนกอาคารสถานที่'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isWide) const SizedBox(width: 20) else const SizedBox(height: 20),
                  Expanded(
                    flex: isWide ? 3 : 0,
                    child: Column(
                      children: const [
                        _PermissionCard(),
                        SizedBox(height: 20),
                        _NotificationCard(),
                        SizedBox(height: 20),
                        _HistoryCard(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('สิทธิ์/บทบาท', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _PermissionChip(icon: Icons.report_gmailerrorred, label: 'สร้าง Ticket'),
                _PermissionChip(icon: Icons.visibility_outlined, label: 'ติดตามงานทั้งหมด'),
                _PermissionChip(icon: Icons.assignment_ind_outlined, label: 'มอบหมายช่าง'),
                _PermissionChip(icon: Icons.analytics_outlined, label: 'ดูรายงาน'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatefulWidget {
  const _NotificationCard();

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool email = true;
  bool mobile = true;
  bool sms = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ช่องทางแจ้งเตือน', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              title: const Text('อีเมล'),
              value: email,
              onChanged: (value) => setState(() => email = value),
            ),
            SwitchListTile.adaptive(
              title: const Text('แอปมือถือ'),
              value: mobile,
              onChanged: (value) => setState(() => mobile = value),
            ),
            SwitchListTile.adaptive(
              title: const Text('SMS'),
              value: sms,
              onChanged: (value) => setState(() => sms = value),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = const [
      'TK-1024 - เครื่องปรับอากาศไม่เย็น',
      'TK-1009 - เปลี่ยนหลอดไฟโถงทางเดิน',
      'TK-0998 - เก้าอี้สำนักงานชำรุด',
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ประวัติการแจ้งซ่อม', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ...history.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: AppColors.mediumGrey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('ดูรายละเอียด'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColors.darkGrey),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
