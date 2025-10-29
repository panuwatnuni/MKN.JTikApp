import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/ticket.dart';
import '../theme/app_theme.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final Ticket _ticket = Ticket(
    id: 'TK-1024',
    title: 'เครื่องปรับอากาศไม่เย็น',
    assetName: 'AC-02-14',
    location: 'อาคาร A / ชั้น 4 / ห้องประชุม',
    status: TicketStatus.inProgress,
    severity: TicketSeverity.high,
    owner: 'Somchai R.',
    assignee: 'Technician A',
    slaMinutesRemaining: 45,
    updatedAt: DateTime.now(),
    timeline: const [
      TimelineStage.created,
      TimelineStage.assigned,
      TimelineStage.repairing,
      TimelineStage.waitingParts,
    ],
  );

  final List<_Message> _messages = [
    _Message(
      author: 'Technician A',
      message: 'เข้าตรวจสอบระบบแล้ว พบว่าแผงคอยล์สกปรก',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isFromTechnician: true,
    ),
    _Message(
      author: 'Somchai R.',
      message: 'ขอความคืบหน้าครับ กำหนดใช้งานบ่ายนี้',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
    ),
  ];

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'ติดตามงาน',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('ปิดงาน'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isWide ? 2 : 0,
                    child: _HeaderCard(ticket: _ticket),
                  ),
                  if (isWide) const SizedBox(width: 20) else const SizedBox(height: 20),
                  Expanded(
                    flex: isWide ? 3 : 0,
                    child: _TimelineCard(ticket: _ticket),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isWide ? 2 : 0,
                    child: _ConversationCard(
                      messages: _messages,
                      controller: _commentController,
                      onSend: _onSend,
                    ),
                  ),
                  if (isWide) const SizedBox(width: 20) else const SizedBox(height: 20),
                  Expanded(
                    flex: isWide ? 3 : 0,
                    child: _ActionPanel(onStatusChange: _onChangeStatus),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSend() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        _Message(
          author: 'You',
          message: text,
          timestamp: DateTime.now(),
          isFromTechnician: false,
        ),
      );
    });
    _commentController.clear();
  }

  void _onChangeStatus(TimelineStage stage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('อัปเดตสถานะเป็น ${_stageLabel(stage)}')),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('dd MMM yyyy HH:mm');
    final color = ticket.isOverdue ? Colors.redAccent : AppColors.primaryBlue;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ticket.status.name.toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text(ticket.severity.name.toUpperCase()),
                  backgroundColor: AppColors.lightBlue,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  ticket.id,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(ticket.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _DetailRow(icon: Icons.precision_manufacturing, label: 'ทรัพย์สิน', value: ticket.assetName),
            const SizedBox(height: 8),
            _DetailRow(icon: Icons.place_outlined, label: 'สถานที่', value: ticket.location),
            const SizedBox(height: 8),
            _DetailRow(icon: Icons.person_outline, label: 'ผู้รับผิดชอบ', value: ticket.assignee),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, color: color),
                const SizedBox(width: 8),
                Text(
                  ticket.isOverdue
                      ? 'เกิน SLA ${ticket.slaMinutesRemaining.abs()} นาที'
                      : 'SLA เหลือ ${ticket.slaMinutesRemaining} นาที',
                  style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('อัปเดตล่าสุด ${formatter.format(ticket.updatedAt)}', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stages = TimelineStage.values;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Timeline', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Stepper(
              physics: const NeverScrollableScrollPhysics(),
              currentStep: ticket.timeline.length - 1,
              controlsBuilder: (context, details) => const SizedBox.shrink(),
              steps: [
                for (int index = 0; index < stages.length; index++)
                  Step(
                    title: Text(_stageLabel(stages[index])),
                    content: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        index < ticket.timeline.length
                            ? 'อัปเดตโดย ${ticket.assignee}'
                            : 'รอดำเนินการ',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    isActive: index < ticket.timeline.length,
                    state: index < ticket.timeline.length
                        ? StepState.complete
                        : StepState.indexed,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({
    required this.messages,
    required this.controller,
    required this.onSend,
  });

  final List<_Message> messages;
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('แชต/คอมเมนต์', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ...messages.map((message) => _MessageBubble(message: message)),
            const Divider(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'พิมพ์ข้อความถึงผู้รับผิดชอบ...',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onSend,
                  icon: const Icon(Icons.send),
                  label: const Text('ส่ง'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _Message message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat.Hm();
    final background = message.isFromTechnician
        ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
        : Colors.white;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                message.isFromTechnician ? Icons.engineering : Icons.person,
                size: 18,
                color: AppColors.mediumGrey,
              ),
              const SizedBox(width: 8),
              Text(
                message.author,
                style: theme.textTheme.titleSmall,
              ),
              const Spacer(),
              Text(
                formatter.format(message.timestamp),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.message,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({required this.onStatusChange});

  final ValueChanged<TimelineStage> onStatusChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('การดำเนินงานของช่าง', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: TimelineStage.values
                  .map(
                    (stage) => OutlinedButton(
                      onPressed: () => onStatusChange(stage),
                      child: Text(_stageLabel(stage)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Text('บันทึกอะไหล่/ค่าแรง', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightBlue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _CostRow(label: 'อะไหล่', value: 'คอยล์ร้อน 1 ชิ้น - 1,800 บาท'),
                  SizedBox(height: 12),
                  _CostRow(label: 'ค่าแรง', value: 'ทีมช่าง 2 คน - 800 บาท'),
                  SizedBox(height: 12),
                  _CostRow(label: 'หมายเหตุ', value: 'รออะไหล่มาถึงภายใน 2 วันทำการ'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('ให้คะแนนความพึงพอใจ', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(
                5,
                (index) => Icon(Icons.star_rounded,
                    size: 28,
                    color: index < 4
                        ? Theme.of(context).colorScheme.primary
                        : AppColors.lightBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
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
    );
  }
}

class _Message {
  const _Message({
    required this.author,
    required this.message,
    required this.timestamp,
    this.isFromTechnician = false,
  });

  final String author;
  final String message;
  final DateTime timestamp;
  final bool isFromTechnician;
}

String _stageLabel(TimelineStage stage) {
  switch (stage) {
    case TimelineStage.created:
      return 'สร้าง';
    case TimelineStage.assigned:
      return 'รับเรื่อง';
    case TimelineStage.repairing:
      return 'กำลังซ่อม';
    case TimelineStage.waitingParts:
      return 'รออะไหล่';
    case TimelineStage.testing:
      return 'ทดสอบ';
    case TimelineStage.done:
      return 'เสร็จสิ้น';
  }
}
