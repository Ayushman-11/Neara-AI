import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';

enum AuthStatus { authenticated, unauthenticated, initial }

class AuthState {
  final AuthStatus status;
  final String? phoneNumber;
  final String? userId;
  final Map<String, dynamic>? profile;

  AuthState({
    required this.status,
    this.phoneNumber,
    this.userId,
    this.profile,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
  factory AuthState.authenticated({
    required String phone,
    required String userId,
    Map<String, dynamic>? profile,
  }) =>
      AuthState(
        status: AuthStatus.authenticated,
        phoneNumber: phone,
        userId: userId,
        profile: profile,
      );
  factory AuthState.unauthenticated() =>
      AuthState(status: AuthStatus.unauthenticated);
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = AuthService();
    _loadAuthState();
    return AuthState.initial();
  }

  Future<void> _loadAuthState() async {
    if (_authService.isLoggedIn) {
      final user = _authService.currentUser!;
      final profile = await _authService.getUserProfile();

      state = AuthState.authenticated(
        phone: user.phone ?? '',
        userId: user.id,
        profile: profile,
      );
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<bool> sendOtp(String phone) async {
    try {
      await _authService.signInWithPhone(phone);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final success = await _authService.verifyOtp(phone, otp);
      if (success) {
        final user = _authService.currentUser!;
        final profile = await _authService.getUserProfile();

        state = AuthState.authenticated(
          phone: phone,
          userId: user.id,
          profile: profile,
        );
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveWorkerProfile({
    required String fullName,
    String? serviceCategoryId,
    double? locationLat,
    double? locationLng,
  }) async {
    await _authService.saveWorkerProfile(
      fullName: fullName,
      serviceCategoryId: serviceCategoryId,
      locationLat: locationLat,
      locationLng: locationLng,
    );

    // Reload profile
    final profile = await _authService.getUserProfile();
    final user = _authService.currentUser!;

    state = AuthState.authenticated(
      phone: user.phone ?? '',
      userId: user.id,
      profile: profile,
    );
  }

  Future<void> updateAvailabilityStatus(String status) async {
    await _authService.updateAvailabilityStatus(status);

    // Reload profile
    final profile = await _authService.getUserProfile();
    final user = _authService.currentUser!;

    state = AuthState.authenticated(
      phone: user.phone ?? '',
      userId: user.id,
      profile: profile,
    );
  }

  Future<void> logout() async {
    await _authService.signOut();
    state = AuthState.unauthenticated();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
