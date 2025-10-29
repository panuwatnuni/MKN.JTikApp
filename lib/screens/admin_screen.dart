import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/ticket.dart';
import '../theme/app_theme.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<Ticket> _tickets = List.generate(
    12,
    (index) => Ticket(
      id: 'TK-${1001 + index}',
      title: index.isEven ? 'อัปเดตระบบคอมพิวเตอร์' : 'ซ่อมไฟฟ้าดับบางส่วน',
      assetName: index.isEven ? 'PC-${index + 1}' : 'ELE-${index + 1}',
      location: index.isEven ? 'อาคาร A / ชั้น 2' : 'อาคาร B / ชั้น 1',
      status: TicketStatus.values[index % TicketStatus.values.length],
      severity: TicketSeverity.values[index % TicketSeverity.values.length],
      owner: 'User ${index + 1}',
      assignee: 'Technician ${(index % 3) + 1}',
      slaMinutesRemaining: 120 - index * 10,
      updatedAt: DateTime.now().subtract(Duration(hours: index)),
      timeline: TimelineStage.values.take((index % 6) + 1).toList(),
    ),
  );

  TicketStatus? _statusFilter;
  TicketSeverity? _categoryFilter;
  String? _technicianFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('dd MMM HH:mm');
    final filteredTickets = _tickets.where((ticket) {
      final matchesStatus = _statusFilter == null || ticket.status == _statusFilter;
      final matchesCategory =
          _categoryFilter == null || ticket.severity == _categoryFilter;
      final matchesTechnician =
          _technicianFilter == null || ticket.assignee == _technicianFilter;
      return matchesStatus && matchesCategory && matchesTechnician;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ศูนย์ควบคุมงาน', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _FilterDropdown<TicketStatus?>(
                label: 'สถานะ',
                value: _statusFilter,
                items: [
                  const DropdownMenuItem(value: null, child: Text('ทั้งหมด')),
                  ...TicketStatus.values.map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.name),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _statusFilter = value),
              ),
              _FilterDropdown<TicketSeverity?>(
                label: 'ความเร่งด่วน',
                value: _categoryFilter,
                items: [
                  const DropdownMenuItem(value: null, child: Text('ทั้งหมด')),
                  ...TicketSeverity.values.map(
                    (severity) => DropdownMenuItem(
                      value: severity,
                      child: Text(severity.name),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _categoryFilter = value),
              ),
              _FilterDropdown<String?>(
                label: 'ช่างผู้รับผิดชอบ',
                value: _technicianFilter,
                items: [
                  const DropdownMenuItem(value: null, child: Text('ทั้งหมด')),
                  ...['Technician 1', 'Technician 2', 'Technician 3'].map(
                    (tech) => DropdownMenuItem(
                      value: tech,
                      child: Text(tech),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _technicianFilter = value),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.assignment_ind_outlined),
                label: const Text('มอบหมายงาน'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Ticket')),
                  DataColumn(label: Text('หัวข้อ')),
                  DataColumn(label: Text('ทรัพย์สิน')),
                  DataColumn(label: Text('สถานที่')),
                  DataColumn(label: Text('สถานะ')),
                  DataColumn(label: Text('ช่าง')),
                  DataColumn(label: Text('SLA (นาที)')),
                  DataColumn(label: Text('อัปเดตล่าสุด')),
                ],
                rows: filteredTickets.map((ticket) {
                  final statusColor = _statusColor(ticket.status);
                  return DataRow(
                    cells: [
                      DataCell(Text(ticket.id)),
                      DataCell(Text(ticket.title)),
                      DataCell(Text(ticket.assetName)),
                      DataCell(Text(ticket.location)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ticket.status.name,
                            style: theme.textTheme.bodyMedium?.copyWith(color: statusColor),
                          ),
                        ),
                      ),
                      DataCell(Text(ticket.assignee)),
                      DataCell(Text(ticket.slaMinutesRemaining.toString())),
                      DataCell(Text(formatter.format(ticket.updatedAt))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _ReportSection(),
        ],
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _ReportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('รายงานสถิติ', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: const [
                _ReportCard(
                  title: 'เวลาซ่อมเฉลี่ย',
                  value: '3 ชม. 45 นาที',
                  trend: '+12% จากสัปดาห์ก่อน',
                ),
                _ReportCard(
                  title: 'งานเกิน SLA',
                  value: '5 รายการ',
                  trend: '-2 รายการ จากเดือนก่อน',
                ),
                _ReportCard(
                  title: 'งานเสร็จสิ้นเดือนนี้',
                  value: '86 งาน',
                  trend: '+18% จากเดือนก่อน',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'การวิเคราะห์แนวโน้ม',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• เพิ่มช่างสำรองในช่วงเวลาเร่งด่วนเพื่อป้องกันงานเกิน SLA\n'
                    '• งานหมวดไฟฟ้าใช้เวลาซ่อมเฉลี่ยสูง ควรอบรมช่างเฉพาะทางเพิ่ม\n'
                    '• ระบบแจ้งเตือนผ่านแอปช่วยลดเวลารับเรื่องลง 30%',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.value,
    required this.trend,
  });

  final String title;
  final String value;
  final String trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                trend,
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.mediumGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _statusColor(TicketStatus status) {
  switch (status) {
    case TicketStatus.pending:
      return AppColors.primaryBlue;
    case TicketStatus.inProgress:
      return AppColors.accentBlue;
    case TicketStatus.waitingParts:
      return AppColors.mediumGrey;
    case TicketStatus.completed:
      return Colors.green;
  }
}
