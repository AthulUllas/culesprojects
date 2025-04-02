import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:culesprojects/models/categorymodel.dart';

// Initialize Supabase client
final supabase = Supabase.instance.client;

class ServicesNotifier extends AsyncNotifier<List<Service>> {
  @override
  Future<List<Service>> build() async {
    return await fetchServices();
  }

  // Fetch Services
  Future<List<Service>> fetchServices() async {
    try {
      final response = await supabase.from('data_base').select();
      return response.map<Service>((json) => Service.fromJson(json)).toList();
    } catch (error) {
      throw Exception("Failed to fetch services: $error");
    }
  }

  // Insert Service
  Future<void> addService(
    String name,
    List<Map<String, dynamic>> details,
  ) async {
    try {
      await supabase.from('data_base').insert({
        "name": name,
        "details": details,
      });

      // Refresh the state after inserting
      state = AsyncData(await fetchServices());
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  // Delete Service
  Future<void> deleteService(String id) async {
    try {
      await supabase.from('data_base').delete().match({'id': id});

      // Refresh the state after deleting
      state = AsyncData(await fetchServices());
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}

// ✅ Use AsyncNotifierProvider instead of NotifierProvider
final servicesProvider = AsyncNotifierProvider<ServicesNotifier, List<Service>>(
  () {
    return ServicesNotifier();
  },
);
