import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OneDayLateAlert extends StatelessWidget {
  const OneDayLateAlert({
    super.key,
    required this.orderId,
    required this.expectedDelivery,
    this.reason,
    this.onTrackOrder,
    this.onContactSupport,
  });

  final String orderId;
  final DateTime expectedDelivery;
  final String? reason;
  final VoidCallback? onTrackOrder;
  final VoidCallback? onContactSupport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('d MMM yyyy', 'th');
    final deliveryText = formatter.format(expectedDelivery);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF22160A), Color(0xFF141414)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, deliveryText),
            const SizedBox(height: 20),
            _buildTimeline(),
            const SizedBox(height: 20),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String deliveryText) {
    final reasonText =
        reason ?? 'พัสดุของคุณล่าช้า 1 วัน ทีมงานกำลังเร่งอัปเดตสถานะล่าสุดให้คุณ';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFDCA8).withOpacity(0.2),
          ),
          child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFC5A253)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'พัสดุล่าช้า 1 วัน',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFDCA8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                reasonText,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2214),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_shipping, size: 16, color: Color(0xFFC5A253)),
                    const SizedBox(width: 6),
                    Text(
                      'คำสั่งซื้อ $orderId',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'กำหนดส่ง $deliveryText',
                      style: theme.textTheme.labelMedium?.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return const Column(
      children: [
        _TimelineTile(
          isCompleted: true,
          title: 'พัสดุออกจากคลังสินค้า',
          subtitle: 'สุวรรณภูมิ, 18:30 น.',
        ),
        _TimelineDivider(),
        _TimelineTile(
          isCompleted: true,
          title: 'อยู่ระหว่างการขนส่ง',
          subtitle: 'กำลังส่งไปยังศูนย์กระจายสินค้าสีลม',
        ),
        _TimelineDivider(),
        _TimelineTile(
          isCompleted: false,
          title: 'กำลังจัดส่งถึงคุณ',
          subtitle: 'ทีมจัดส่งจะติดต่อคุณภายในวันนี้',
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackButton = Expanded(
          child: OutlinedButton.icon(
            onPressed: onTrackOrder ?? () => _showFallbackSnackBar(context, 'กำลังติดตามพัสดุ'),
            icon: const Icon(Icons.map_outlined),
            label: const Text('ติดตามพัสดุ'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFC5A253)),
              foregroundColor: const Color(0xFFC5A253),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        );
        const spacer = SizedBox(width: 12);
        final conciergeButton = Expanded(
          child: ElevatedButton.icon(
            onPressed:
                onContactSupport ?? () => _showFallbackSnackBar(context, 'ทีมคอนเซียร์จจะติดต่อกลับโดยเร็ว'),
            icon: const Icon(Icons.headset_mic_outlined),
            label: const Text('ติดต่อคอนเซียร์จ'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color(0xFFC5A253),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        );

        if (constraints.maxWidth < 480) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              trackButton,
              const SizedBox(height: 12),
              conciergeButton,
            ],
          );
        }

        return Row(children: [trackButton, spacer, conciergeButton]);
      },
    );
  }

  void _showFallbackSnackBar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.isCompleted,
    required this.title,
    required this.subtitle,
  });

  final bool isCompleted;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusBullet(isCompleted: isCompleted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineDivider extends StatelessWidget {
  const _TimelineDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: const [
          SizedBox(
            width: 16,
            child: VerticalDivider(
              color: Colors.white24,
              width: 1,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _StatusBullet extends StatelessWidget {
  const _StatusBullet({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      alignment: Alignment.center,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? const Color(0xFFC5A253) : Colors.transparent,
          border: Border.all(
            color: const Color(0xFFC5A253),
            width: 2,
          ),
        ),
      ),
    );
  }
}
