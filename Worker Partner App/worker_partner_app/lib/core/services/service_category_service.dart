import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/supabase_config.dart';

class ServiceCategory {
  final String id;
  final String name;
  final String? iconUrl;
  final DateTime createdAt;

  const ServiceCategory({
    required this.id,
    required this.name,
    this.iconUrl,
    required this.createdAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'],
      name: json['name'],
      iconUrl: json['icon_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ServiceCategoryService {
  final _client = SupabaseConfig.client;

  Future<List<ServiceCategory>> getAllCategories() async {
    try {
      final response = await _client
          .from('service_categories')
          .select()
          .order('name', ascending: true);

      return (response as List)
          .map((json) => ServiceCategory.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<ServiceCategory?> getCategoryById(String id) async {
    try {
      final response = await _client
          .from('service_categories')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        return ServiceCategory.fromJson(response);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

final serviceCategoryServiceProvider = Provider<ServiceCategoryService>((ref) {
  return ServiceCategoryService();
});

final serviceCategoriesProvider =
    FutureProvider<List<ServiceCategory>>((ref) async {
  final service = ref.watch(serviceCategoryServiceProvider);
  return service.getAllCategories();
});
