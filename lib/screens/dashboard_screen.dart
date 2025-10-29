import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/ticket.dart';
import '../theme/app_theme.dart';
import '../widgets/status_pie_chart.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
  });

  DashboardSummary get _summary => DashboardSummary(
        pending: 12,
        inProgress: 8,
        waitingParts: 5,
        completed: 36,
      );

  List<Ticket> get _slaAlerts => [
        Ticket(
          id: 'TK-1024',
          title: 'เครื่องปรับอากาศไม่เย็น',
          assetName: 'AC-02-14',
          location: 'อาคาร A / ชั้น 4 / ห้องประชุม',
          status: TicketStatus.inProgress,
          severity: TicketSeverity.high,
          owner: 'Somchai R.',
          assignee: 'Technician A',
          slaMinutesRemaining: 45,
          updatedAt: DateTime.now().subtract(const Duration(minutes: 18)),
          timeline: const [
            TimelineStage.created,
            TimelineStage.assigned,
            TimelineStage.repairing,
          ],
        ),
        Ticket(
          id: 'TK-1031',
          title: 'ปลั๊กไฟชำรุด',
          assetName: 'ELE-09-01',
          location: 'อาคาร B / ชั้น 2 / โถงทางเดิน',
          status: TicketStatus.pending,
          severity: TicketSeverity.medium,
          owner: 'Nattapong S.',
          assignee: 'Technician B',
          slaMinutesRemaining: -15,
          updatedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          timeline: const [TimelineStage.created],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = _summary;
    final alerts = _slaAlerts;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('แดชบอร์ด', style: theme.textTheme.headlineSmall),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('แจ้งซ่อมใหม่'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: isWide ? 7 : 0,
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth - 60) / 3
                                    : constraints.maxWidth,
                                child: SummaryCard(
                                  title: 'รอดำเนินการ',
                                  count: summary.pending,
                                  subtitle: 'งานที่ต้องรับเรื่อง',
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth - 60) / 3
                                    : constraints.maxWidth,
                                child: SummaryCard(
                                  title: 'กำลังดำเนินการ',
                                  count: summary.inProgress,
                                  subtitle: 'ช่างกำลังแก้ไข',
                                  color: AppColors.accentBlue,
                                ),
                              ),
                              SizedBox(
                                width: isWide
                                    ? (constraints.maxWidth - 60) / 3
                                    : constraints.maxWidth,
                                child: SummaryCard(
                                  title: 'รออะไหล่',
                                  count: summary.waitingParts,
                                  subtitle: 'ต้องติดตามผู้จัดซื้อ',
                                  color: AppColors.mediumGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isWide) const SizedBox(width: 20) else const SizedBox(height: 20),
                        Expanded(
                          flex: isWide ? 5 : 0,
                          child: StatusPieChart(summary: summary),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          sliver: SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications_active,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'งานใกล้ครบกำหนด (SLA)',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ...alerts.map(
                      (ticket) => _SlaAlertTile(ticket: ticket),
                    ),
                    if (alerts.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'ยังไม่มีงานที่ใกล้ครบกำหนด',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlaAlertTile extends StatelessWidget {
  const _SlaAlertTile({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat.Hm();
    final color = ticket.isOverdue ? Colors.redAccent : AppColors.primaryBlue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.timer_outlined, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ticket.title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(ticket.severity.name.toUpperCase()),
                      backgroundColor: color.withOpacity(0.12),
                      labelStyle: theme.textTheme.bodyMedium
                          ?.copyWith(color: color, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _InfoRow(icon: Icons.confirmation_number, text: ticket.id),
                    _InfoRow(icon: Icons.precision_manufacturing, text: ticket.assetName),
                    _InfoRow(icon: Icons.place_outlined, text: ticket.location),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 18, color: AppColors.mediumGrey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'ผู้รับผิดชอบ: ${ticket.assignee}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      ticket.isOverdue
                          ? 'เกินกำหนด ${ticket.slaMinutesRemaining.abs()} นาที'
                          : 'เหลือเวลา ${ticket.slaMinutesRemaining} นาที',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: color, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'อัปเดตล่าสุด ${formatter.format(ticket.updatedAt)} น.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.mediumGrey),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.darkGrey),
          ),
        ),
      ],
    );
  }
}
