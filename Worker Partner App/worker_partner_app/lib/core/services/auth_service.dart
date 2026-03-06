import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => _client.auth.currentUser != null;
  String? get userPhone => currentUser?.phone;

  /// Send OTP to the given phone number (E.164 format, e.g. +919876543210)
  Future<void> signInWithPhone(String phone) async {
    debugPrint('[AuthService] Sending OTP to $phone');
    await _client.auth.signInWithOtp(phone: phone);
  }

  /// Verify OTP and sign in. Returns true if successful.
  Future<bool> verifyOtp(String phone, String token) async {
    try {
      debugPrint('[AuthService] Verifying OTP for $phone');
      final response = await _client.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      );
      debugPrint('[AuthService] Session: ${response.session?.user.id}');
      return response.session != null;
    } catch (e) {
      debugPrint('[AuthService] OTP verification error: $e');
      rethrow;
    }
  }

  /// Check if the logged-in user already has a profile row
  Future<bool> hasProfile() async {
    final uid = currentUser?.id;
    if (uid == null) return false;
    final result =
        await _client.from('profiles').select('id').eq('id', uid).maybeSingle();
    return result != null;
  }

  /// Create or update worker profile
  Future<void> saveWorkerProfile({
    required String fullName,
    String? serviceCategoryId,
    double? locationLat,
    double? locationLng,
  }) async {
    final uid = currentUser?.id;
    final phone = currentUser?.phone;
    if (uid == null) return;

    debugPrint('[AuthService] Upserting worker profile for $uid');
    await _client.from('profiles').upsert({
      'id': uid,
      'role': 'worker',
      'full_name': fullName,
      'phone_number': phone,
      'service_category_id': serviceCategoryId,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'availability_status': 'available',
    });
  }

  /// Get current user's profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = currentUser?.id;
    if (uid == null) return null;

    final result =
        await _client.from('profiles').select().eq('id', uid).maybeSingle();
    return result;
  }

  /// Update worker availability status
  Future<void> updateAvailabilityStatus(String status) async {
    final uid = currentUser?.id;
    if (uid == null) return;

    await _client.from('profiles').update({
      'availability_status': status,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', uid);
  }

  /// Sign out user
  Future<void> signOut() async {
    debugPrint('[AuthService] Signing out user');
    await _client.auth.signOut();
  }
}
