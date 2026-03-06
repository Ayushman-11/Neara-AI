import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/service_request.dart';

enum JobStatus {
  idle,
  negotiating,
  waitingEscrow,
  escrowSigning,
  coming, // Navigation
  arrived,
  started,
  completing,
  waitingFinalPayment,
  closed,
}

class ActiveJob {
  final String id;
  final String customerName;
  final String serviceType;
  final String customerAddress;
  final double agreedAmount;
  final double advancePercentage;
  final String riskLevel;
  final List<String> beforePhotos;
  final List<String> afterPhotos;
  final DateTime? startedAt;
  final ServiceRequest? serviceRequest;

  ActiveJob({
    required this.id,
    required this.customerName,
    required this.serviceType,
    this.customerAddress = '123, Luxury Enclave, Mumbai',
    required this.agreedAmount,
    this.advancePercentage = 0.20,
    this.riskLevel = 'NORMAL',
    this.beforePhotos = const [],
    this.afterPhotos = const [],
    this.startedAt,
    this.serviceRequest,
  });

  factory ActiveJob.fromServiceRequest(ServiceRequest request) {
    return ActiveJob(
      id: request.id,
      customerName: 'Customer', // Will be populated from profile lookup
      serviceType: 'Service', // Will be populated from category lookup
      customerAddress: '${request.locationLat}, ${request.locationLng}',
      agreedAmount: request.totalCost ?? 0.0,
      serviceRequest: request,
    );
  }

  ActiveJob copyWith({
    String? id,
    String? customerName,
    String? serviceType,
    String? customerAddress,
    double? agreedAmount,
    double? advancePercentage,
    String? riskLevel,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
    DateTime? startedAt,
    ServiceRequest? serviceRequest,
  }) {
    return ActiveJob(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      serviceType: serviceType ?? this.serviceType,
      customerAddress: customerAddress ?? this.customerAddress,
      agreedAmount: agreedAmount ?? this.agreedAmount,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      riskLevel: riskLevel ?? this.riskLevel,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      startedAt: startedAt ?? this.startedAt,
      serviceRequest: serviceRequest ?? this.serviceRequest,
    );
  }
}

class PastJob {
  final String id;
  final String customerName;
  final String serviceType;
  final double amount;
  final DateTime date;
  final String status; // COMPLETED, CANCELLED

  PastJob({
    required this.id,
    required this.customerName,
    required this.serviceType,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class WorkerState {
  final String name;
  final String? photoPath;
  final bool isOnline;
  final bool notificationsEnabled;
  final double serviceRadius;
  final List<String> selectedCategories;
  final double walletBalance;
  final List<ServiceRequest> nearbyRequests;
  final List<PastJob> jobHistory;

  // New Polish Fields
  final double baseInspectionFee;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String workingHours;
  final double rating;
  final int completedJobs;
  final String language;
  final String kycStatus; // Approved, Pending, Under Review
  final String verifiedDate;

  // Job Lifecycle
  final JobStatus jobStatus;
  final ActiveJob? activeJob;

  WorkerState({
    required this.name,
    this.photoPath,
    required this.isOnline,
    required this.notificationsEnabled,
    required this.serviceRadius,
    required this.selectedCategories,
    required this.walletBalance,
    required this.nearbyRequests,
    required this.jobHistory,
    required this.baseInspectionFee,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.workingHours,
    required this.rating,
    required this.completedJobs,
    required this.language,
    required this.kycStatus,
    required this.verifiedDate,
    this.jobStatus = JobStatus.idle,
    this.activeJob,
  });

  WorkerState copyWith({
    String? name,
    String? photoPath,
    bool? isOnline,
    bool? notificationsEnabled,
    double? serviceRadius,
    List<String>? selectedCategories,
    double? walletBalance,
    List<ServiceRequest>? nearbyRequests,
    List<PastJob>? jobHistory,
    double? baseInspectionFee,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? workingHours,
    double? rating,
    int? completedJobs,
    String? language,
    String? kycStatus,
    String? verifiedDate,
    JobStatus? jobStatus,
    ActiveJob? activeJob,
  }) {
    return WorkerState(
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      isOnline: isOnline ?? this.isOnline,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      serviceRadius: serviceRadius ?? this.serviceRadius,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      walletBalance: walletBalance ?? this.walletBalance,
      nearbyRequests: nearbyRequests ?? this.nearbyRequests,
      jobHistory: jobHistory ?? this.jobHistory,
      baseInspectionFee: baseInspectionFee ?? this.baseInspectionFee,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      workingHours: workingHours ?? this.workingHours,
      rating: rating ?? this.rating,
      completedJobs: completedJobs ?? this.completedJobs,
      language: language ?? this.language,
      kycStatus: kycStatus ?? this.kycStatus,
      verifiedDate: verifiedDate ?? this.verifiedDate,
      jobStatus: jobStatus ?? this.jobStatus,
      activeJob: activeJob ?? this.activeJob,
    );
  }
}

class WorkerNotifier extends Notifier<WorkerState> {
  @override
  WorkerState build() {
    // Start with empty/defaults, then load profile async
    Future.microtask(() => loadProfile());
    return WorkerState(
      name: '',
      isOnline: false,
      notificationsEnabled: true,
      serviceRadius: 5.0,
      selectedCategories: [],
      walletBalance: 0.0,
      baseInspectionFee: 0.0,
      bankName: '',
      accountNumber: '',
      ifscCode: '',
      workingHours: '',
      rating: 0.0,
      completedJobs: 0,
      language: 'English',
      kycStatus: 'Pending',
      verifiedDate: '',
      jobHistory: [],
      nearbyRequests: [],
    );
  }

  Future<void> loadProfile() async {
    final client = Supabase.instance.client;
    final uid = client.auth.currentUser?.id;
    if (uid == null) return;

    try {
      final profile = await client
          .from('profiles')
          .select('*, service_categories(name)')
          .eq('id', uid)
          .maybeSingle();
      if (profile == null) return;

      // Fetch completed jobs from service_requests
      final completedJobs = await client
          .from('service_requests')
          .select('id')
          .eq('worker_id', uid)
          .eq('status', ServiceRequestStatus.serviceClosed);

      // Fetch wallet balance: sum of released payments for this worker
      final payments = await client
          .from('payments')
          .select('amount')
          .eq('payee_id', uid)
          .eq('status', 'RELEASED');

      final wallet = (payments as List)
          .fold<double>(0, (sum, p) => sum + ((p['amount'] as num).toDouble()));

      state = state.copyWith(
        name: profile['full_name'] ?? '',
        isOnline: (profile['availability_status'] ?? 'offline') == 'available',
        selectedCategories: profile['service_categories'] != null
            ? [profile['service_categories']['name'] as String]
            : [],
        walletBalance: wallet,
        rating: (profile['rating_avg'] as num?)?.toDouble() ?? 0.0,
        completedJobs: (completedJobs as List).length,
        kycStatus: 'Approved',
      );
    } catch (e) {
      // Keep defaults on error
    }
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void toggleOnline(bool value) {
    state = state.copyWith(isOnline: value);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void updateRadius(double radius) {
    state = state.copyWith(serviceRadius: radius);
  }

  void updateCategories(List<String> categories) {
    state = state.copyWith(selectedCategories: categories);
  }

  void updateFees(double fee) {
    state = state.copyWith(baseInspectionFee: fee);
  }

  void updateWorkingHours(String hours) {
    state = state.copyWith(workingHours: hours);
  }

  void updateBankDetails(String bank, String acc, String ifsc) {
    state = state.copyWith(bankName: bank, accountNumber: acc, ifscCode: ifsc);
  }

  void updateLanguage(String lang) {
    state = state.copyWith(language: lang);
  }

  void ignoreRequest(String id) {
    state = state.copyWith(
      nearbyRequests: state.nearbyRequests.where((r) => r.id != id).toList(),
    );
  }

  void withdrawFunds(double amount) {
    if (state.walletBalance >= amount) {
      state = state.copyWith(walletBalance: state.walletBalance - amount);
    }
  }

  // Lifecycle Transitions
  void startNegotiation(ServiceRequest request, double agreedAmount) {
    state = state.copyWith(
      jobStatus: JobStatus.negotiating,
      activeJob: ActiveJob.fromServiceRequest(request).copyWith(
        agreedAmount: agreedAmount,
        riskLevel: request.urgency == 'emergency' ? 'HIGH' : 'NORMAL',
      ),
      nearbyRequests:
          state.nearbyRequests.where((r) => r.id != request.id).toList(),
    );
  }

  void updateJobStatus(JobStatus status) {
    state = state.copyWith(jobStatus: status);
  }

  void updateAgreedAmount(double amount) {
    if (state.activeJob != null) {
      state = state.copyWith(
        activeJob: state.activeJob!.copyWith(agreedAmount: amount),
      );
    }
  }

  void addJobPhoto(String path, {bool isBefore = true}) {
    if (state.activeJob != null) {
      final photos = isBefore
          ? [...state.activeJob!.beforePhotos, path]
          : [...state.activeJob!.afterPhotos, path];
      state = state.copyWith(
        activeJob: isBefore
            ? state.activeJob!.copyWith(beforePhotos: photos)
            : state.activeJob!.copyWith(afterPhotos: photos),
      );
    }
  }

  void completeJob() {
    if (state.activeJob != null) {
      final total = state.activeJob!.agreedAmount;
      state = state.copyWith(
        walletBalance: state.walletBalance + total,
        completedJobs: state.completedJobs + 1,
        jobStatus: JobStatus.closed,
      );
    }
  }

  void resetJob() {
    state = state.copyWith(jobStatus: JobStatus.idle, activeJob: null);
  }

  // Called by booking provider to refresh nearby requests
  void updateFromBookingData(List<ServiceRequest> requests) {
    state = state.copyWith(nearbyRequests: requests);
  }
}

final workerProvider = NotifierProvider<WorkerNotifier, WorkerState>(() {
  return WorkerNotifier();
});
