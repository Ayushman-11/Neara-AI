class Proposal {
  final String id;
  final String serviceRequestId;
  final String workerId;
  final double inspectionFee;
  final double estimatedCost;
  final int advancePercent;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Proposal({
    required this.id,
    required this.serviceRequestId,
    required this.workerId,
    required this.inspectionFee,
    required this.estimatedCost,
    required this.advancePercent,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'],
      serviceRequestId: json['service_request_id'],
      workerId: json['worker_id'],
      inspectionFee: (json['inspection_fee'] as num?)?.toDouble() ?? 0.0,
      estimatedCost: (json['estimated_cost'] as num?)?.toDouble() ?? 0.0,
      advancePercent: (json['advance_percent'] as int?) ?? 0,
      notes: json['notes'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_request_id': serviceRequestId,
      'worker_id': workerId,
      'inspection_fee': inspectionFee,
      'estimated_cost': estimatedCost,
      'advance_percent': advancePercent,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get advanceAmount => (estimatedCost * advancePercent) / 100;
}

class ProposalStatus {
  static const String pending = 'PENDING';
  static const String accepted = 'ACCEPTED';
  static const String rejected = 'REJECTED';
}
