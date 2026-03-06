import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/models/service_request.dart';
import '../../../core/models/proposal.dart';

class BookingState {
  final List<ServiceRequest> availableRequests;
  final List<ServiceRequest> assignedRequests;
  final List<Proposal> proposals;
  final bool isLoading;
  final String? error;

  const BookingState({
    this.availableRequests = const [],
    this.assignedRequests = const [],
    this.proposals = const [],
    this.isLoading = false,
    this.error,
  });

  BookingState copyWith({
    List<ServiceRequest>? availableRequests,
    List<ServiceRequest>? assignedRequests,
    List<Proposal>? proposals,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      availableRequests: availableRequests ?? this.availableRequests,
      assignedRequests: assignedRequests ?? this.assignedRequests,
      proposals: proposals ?? this.proposals,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BookingNotifier extends Notifier<BookingState> {
  late final BookingService _bookingService;

  @override
  BookingState build() {
    _bookingService = ref.read(bookingServiceProvider);
    loadBookings();
    return const BookingState();
  }

  Future<void> loadBookings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final allRequests = await _bookingService.getWorkerRequests();
      final proposals = await _bookingService.getWorkerProposals();

      // Separate available requests from assigned ones
      final availableRequests = allRequests
          .where(
              (request) => request.status == ServiceRequestStatus.requestSent)
          .toList();

      final assignedRequests =
          allRequests.where((request) => request.workerId != null).toList();

      state = state.copyWith(
        availableRequests: availableRequests,
        assignedRequests: assignedRequests,
        proposals: proposals,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> acceptRequest(String requestId) async {
    final success = await _bookingService.acceptServiceRequest(requestId);
    if (success) {
      await loadBookings();
    }
    return success;
  }

  Future<bool> createProposal({
    required String serviceRequestId,
    required double inspectionFee,
    required double estimatedCost,
    required int advancePercent,
    String? notes,
  }) async {
    final success = await _bookingService.createProposal(
      serviceRequestId: serviceRequestId,
      inspectionFee: inspectionFee,
      estimatedCost: estimatedCost,
      advancePercent: advancePercent,
      notes: notes,
    );

    if (success) {
      await loadBookings();
    }
    return success;
  }

  Future<bool> updateServiceStatus(String requestId, String status) async {
    final success =
        await _bookingService.updateServiceStatus(requestId, status);
    if (success) {
      await loadBookings();
    }
    return success;
  }

  Stream<ServiceRequest> listenToServiceRequest(String requestId) {
    return _bookingService.listenToServiceRequest(requestId);
  }
}

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService();
});

final bookingProvider = NotifierProvider<BookingNotifier, BookingState>(() {
  return BookingNotifier();
});
