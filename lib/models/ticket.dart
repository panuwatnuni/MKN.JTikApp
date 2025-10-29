enum TicketStatus {
  pending,
  inProgress,
  waitingParts,
  completed,
}

enum TicketSeverity {
  low,
  medium,
  high,
  urgent,
}

enum TimelineStage {
  created,
  assigned,
  repairing,
  waitingParts,
  testing,
  done,
}

class Ticket {
  Ticket({
    required this.id,
    required this.title,
    required this.assetName,
    required this.location,
    required this.status,
    required this.severity,
    required this.owner,
    required this.assignee,
    required this.slaMinutesRemaining,
    required this.updatedAt,
    required this.timeline,
  });

  final String id;
  final String title;
  final String assetName;
  final String location;
  final TicketStatus status;
  final TicketSeverity severity;
  final String owner;
  final String assignee;
  final int slaMinutesRemaining;
  final DateTime updatedAt;
  final List<TimelineStage> timeline;

  bool get isOverdue => slaMinutesRemaining <= 0;
}

class DashboardSummary {
  DashboardSummary({
    required this.pending,
    required this.inProgress,
    required this.waitingParts,
    required this.completed,
  });

  final int pending;
  final int inProgress;
  final int waitingParts;
  final int completed;

  int get total => pending + inProgress + waitingParts + completed;
}
