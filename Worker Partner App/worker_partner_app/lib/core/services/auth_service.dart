import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => _client.auth.currentUser != null;
  String? get userPhone => currentUser?.phone;
  String? get userEmail => currentUser?.email;

  /// Sign in with mobile number and password (Worker)
  Future<AuthResponse> signInWithMobilePassword(String mobile, String password) async {
    try {
      debugPrint('[Worker AuthService] Signing in with mobile: $mobile');
      // Use email format with mobile for Supabase compatibility
      final email = '${mobile.replaceAll('+', '')}@neara.worker';
      
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      debugPrint('[Worker AuthService] Sign in successful: ${response.user?.id}');
      return response;
    } catch (e) {
      debugPrint('[Worker AuthService] Sign in error: $e');
      rethrow;
    }
  }

  /// Sign up with mobile number and password (Worker)
  Future<AuthResponse> signUpWithMobilePassword(
    String mobile, 
    String password, 
    String fullName,
    String category,
  ) async {
    try {
      debugPrint('[Worker AuthService] Signing up with mobile: $mobile');
      // Use email format with mobile for Supabase compatibility
      final email = '${mobile.replaceAll('+', '')}@neara.worker';
      
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'mobile': mobile,
          'role': 'worker',
          'service_category': category,
        },
      );
      
      debugPrint('[Worker AuthService] Sign up successful: ${response.user?.id}');
      return response;
    } catch (e) {
      debugPrint('[Worker AuthService] Sign up error: $e');
      rethrow;
    }
  }

  /// Reset password using mobile number
  Future<void> resetPassword(String mobile) async {
    try {
      debugPrint('[Worker AuthService] Resetting password for mobile: $mobile');
      final email = '${mobile.replaceAll('+', '')}@neara.worker';
      
      await _client.auth.resetPasswordForEmail(email);
      debugPrint('[Worker AuthService] Password reset email sent');
    } catch (e) {
      debugPrint('[Worker AuthService] Password reset error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      debugPrint('[Worker AuthService] Signing out');
      await _client.auth.signOut();
    } catch (e) {
      debugPrint('[Worker AuthService] Sign out error: $e');
      rethrow;
    }
  }

  /// Check if the logged-in worker has completed profile setup
  Future<bool> hasWorkerProfile() async {
    final uid = currentUser?.id;
    if (uid == null) return false;
    
    try {
      final result = await _client
          .from('workers')
          .select('id, is_verified')
          .eq('user_id', uid)
          .maybeSingle();
      return result != null;
    } catch (e) {
      debugPrint('[Worker AuthService] Profile check error: $e');
      return false;
    }
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
