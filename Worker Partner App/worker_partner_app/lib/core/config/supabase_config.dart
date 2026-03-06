import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://dusgfqvvjtpdnstjwjvv.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR1c2dmcXZ2anRwZG5zdGp3anZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI2ODA1NzQsImV4cCI6MjA4ODI1NjU3NH0.gt_xy2IVAEOhei1hwgO8EW6wC9q5nmjb5xZAKM_Jimk';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
