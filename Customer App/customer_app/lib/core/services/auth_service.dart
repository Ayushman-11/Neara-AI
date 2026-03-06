import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => _client.auth.currentUser != null;

  /// Sign in with mobile number and password
  Future<AuthResponse> signInWithMobilePassword(String mobile, String password) async {
    try {
      debugPrint('[AuthService] Signing in with mobile: $mobile');
      // Use email format with mobile for Supabase compatibility
      final email = '${mobile.replaceAll('+', '')}@neara.local';
      
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      debugPrint('[AuthService] Sign in successful: ${response.user?.id}');
      return response;
    } catch (e) {
      debugPrint('[AuthService] Sign in error: $e');
      rethrow;
    }
  }

  /// Sign up with mobile number and password
  Future<AuthResponse> signUpWithMobilePassword(
    String mobile, 
    String password, 
    String fullName
  ) async {
    try {
      debugPrint('[AuthService] Signing up with mobile: $mobile');
      // Use email format with mobile for Supabase compatibility
      final email = '${mobile.replaceAll('+', '')}@neara.local';
      
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'mobile': mobile,
          'role': 'customer',
        },
      );
      
      debugPrint('[AuthService] Sign up successful: ${response.user?.id}');
      return response;
    } catch (e) {
      debugPrint('[AuthService] Sign up error: $e');
      rethrow;
    }
  }

  /// Reset password using mobile number
  Future<void> resetPassword(String mobile) async {
    try {
      debugPrint('[AuthService] Resetting password for mobile: $mobile');
      final email = '${mobile.replaceAll('+', '')}@neara.local';
      
      await _client.auth.resetPasswordForEmail(email);
      debugPrint('[AuthService] Password reset email sent');
    } catch (e) {
      debugPrint('[AuthService] Password reset error: $e');
      rethrow;
    }
  }

  /// Check if the logged-in user already has a profile row
  Future<bool> hasProfile() async {
    final uid = currentUser?.id;
    if (uid == null) return false;
    final result = await _client
        .from('profiles')
        .select('id')
        .eq('id', uid)
        .maybeSingle();
    return result != null;
  }

  /// Upsert the user's profile row after first login
  Future<void> saveProfile(String fullName, {String? city}) async {
    final uid = currentUser?.id;
    final phone = currentUser?.phone;
    if (uid == null) return;

    debugPrint('[AuthService] Saving profile for $uid');
    await _client.from('profiles').upsert({
      'id': uid,
      'full_name': fullName,
      'phone_number': phone,
      'role': 'customer',
      if (city != null && city.isNotEmpty) 'city': city,
    });
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
