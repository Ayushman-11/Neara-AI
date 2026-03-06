import 'package:flutter/foundation.dart';
import '../config/supabase_config.dart';
import '../models/service_request.dart';
import '../models/proposal.dart';

class BookingService {
  final _client = SupabaseConfig.client;

  /// Get service requests for the current worker
  Future<List<ServiceRequest>> getWorkerRequests() async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) return [];

    try {
      final response = await _client
          .from('service_requests')
          .select()
          .or('worker_id.eq.$workerId,status.eq.REQUEST_SENT')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ServiceRequest.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('[BookingService] Error fetching worker requests: $e');
      return [];
    }
  }

  /// Get proposals made by the current worker
  Future<List<Proposal>> getWorkerProposals() async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) return [];

    try {
      final response = await _client
          .from('proposals')
          .select()
          .eq('worker_id', workerId)
          .order('created_at', ascending: false);

      return (response as List).map((json) => Proposal.fromJson(json)).toList();
    } catch (e) {
      debugPrint('[BookingService] Error fetching worker proposals: $e');
      return [];
    }
  }

  /// Accept a service request
  Future<bool> acceptServiceRequest(String requestId) async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) return false;

    try {
      await _client.from('service_requests').update({
        'worker_id': workerId,
        'status': ServiceRequestStatus.requestAccepted,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', requestId);

      return true;
    } catch (e) {
      debugPrint('[BookingService] Error accepting request: $e');
      return false;
    }
  }

  /// Create a proposal for a service request
  Future<bool> createProposal({
    required String serviceRequestId,
    required double inspectionFee,
    required double estimatedCost,
    required int advancePercent,
    String? notes,
  }) async {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) return false;

    try {
      await _client.from('proposals').insert({
        'service_request_id': serviceRequestId,
        'worker_id': workerId,
        'inspection_fee': inspectionFee,
        'estimated_cost': estimatedCost,
        'advance_percent': advancePercent,
        'notes': notes,
        'status': ProposalStatus.pending,
      });

      // Update service request status
      await _client.from('service_requests').update({
        'status': ServiceRequestStatus.proposalSent,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', serviceRequestId);

      return true;
    } catch (e) {
      debugPrint('[BookingService] Error creating proposal: $e');
      return false;
    }
  }

  /// Update service request status
  Future<bool> updateServiceStatus(String requestId, String status) async {
    try {
      await _client.from('service_requests').update({
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', requestId);

      return true;
    } catch (e) {
      debugPrint('[BookingService] Error updating service status: $e');
      return false;
    }
  }

  /// Get service request details
  Future<ServiceRequest?> getServiceRequest(String requestId) async {
    try {
      final response = await _client
          .from('service_requests')
          .select()
          .eq('id', requestId)
          .maybeSingle();

      if (response != null) {
        return ServiceRequest.fromJson(response);
      }
      return null;
    } catch (e) {
      debugPrint('[BookingService] Error fetching service request: $e');
      return null;
    }
  }

  /// Listen to service request updates
  Stream<ServiceRequest> listenToServiceRequest(String requestId) {
    return _client
        .from('service_requests')
        .stream(primaryKey: ['id'])
        .eq('id', requestId)
        .map((data) => ServiceRequest.fromJson(data.first));
  }

  /// Listen to proposal updates
  Stream<List<Proposal>> listenToWorkerProposals() {
    final workerId = _client.auth.currentUser?.id;
    if (workerId == null) return Stream.value([]);

    return _client
        .from('proposals')
        .stream(primaryKey: ['id'])
        .eq('worker_id', workerId)
        .map((data) => data.map((json) => Proposal.fromJson(json)).toList());
  }
}
