class ServiceRequest {
  final String id;
  final String customerId;
  final String? workerId;
  final String categoryId;
  final String problemDescription;
  final String urgency;
  final String status;
  final double locationLat;
  final double locationLng;
  final double? totalCost;
  final double advancePaid;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceRequest({
    required this.id,
    required this.customerId,
    this.workerId,
    required this.categoryId,
    required this.problemDescription,
    required this.urgency,
    required this.status,
    required this.locationLat,
    required this.locationLng,
    this.totalCost,
    required this.advancePaid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'],
      customerId: json['customer_id'],
      workerId: json['worker_id'],
      categoryId: json['category_id'],
      problemDescription: json['problem_description'],
      urgency: json['urgency'],
      status: json['status'],
      locationLat: (json['location_lat'] as num).toDouble(),
      locationLng: (json['location_lng'] as num).toDouble(),
      totalCost: json['total_cost']?.toDouble(),
      advancePaid: (json['advance_paid'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'worker_id': workerId,
      'category_id': categoryId,
      'problem_description': problemDescription,
      'urgency': urgency,
      'status': status,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'total_cost': totalCost,
      'advance_paid': advancePaid,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ServiceRequestStatus {
  static const String requestSent = 'REQUEST_SENT';
  static const String requestAccepted = 'REQUEST_ACCEPTED';
  static const String proposalSent = 'PROPOSAL_SENT';
  static const String negotiation = 'NEGOTIATION';
  static const String advancePaid = 'ADVANCE_PAID';
  static const String workerComing = 'WORKER_COMING';
  static const String workerArrived = 'WORKER_ARRIVED';
  static const String serviceStarted = 'SERVICE_STARTED';
  static const String serviceCompleted = 'SERVICE_COMPLETED';
  static const String finalPaymentPending = 'FINAL_PAYMENT_PENDING';
  static const String serviceClosed = 'SERVICE_CLOSED';
}

class ServiceUrgency {
  static const String normal = 'normal';
  static const String emergency = 'emergency';
}
