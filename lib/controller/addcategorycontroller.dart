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

  Future<void> addDetailToService(
    String id,
    Map<String, dynamic> newDetail,
  ) async {
    try {
      // Fetch the existing service
      final response =
          await supabase
              .from('data_base')
              .select('details')
              .eq('id', id)
              .single();

      // Extract current details list
      List<Map<String, dynamic>> currentDetails =
          List<Map<String, dynamic>>.from(response['details']);

      // Append the new detail
      currentDetails.add(newDetail);

      // Update the service with the modified details
      await supabase
          .from('data_base')
          .update({'details': currentDetails})
          .match({'id': id});

      // Refresh state after update
      state = AsyncData(await fetchServices());
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> removeDetailFromService(
    String id,
    Map<String, dynamic> detailToRemove,
  ) async {
    try {
      // Fetch the existing service's details list
      final response =
          await supabase
              .from('services')
              .select('details')
              .eq('id', id)
              .single();

      // Convert the JSON response to a List<Map<String, dynamic>>
      List<Map<String, dynamic>> currentDetails =
          List<Map<String, dynamic>>.from(response['details']);

      // Remove the matching detail map
      currentDetails.removeWhere((detail) => _isEqual(detail, detailToRemove));

      // Update the details list in Supabase
      await supabase.from('services').update({'details': currentDetails}).match(
        {'id': id},
      );

      // Refresh state after update
      state = AsyncData(await fetchServices());
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  // Helper function to check if two maps are equal
  bool _isEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    return a.toString() == b.toString(); // Simple comparison method
  }
}

// ✅ Use AsyncNotifierProvider instead of NotifierProvider
final servicesProvider = AsyncNotifierProvider<ServicesNotifier, List<Service>>(
  () {
    return ServicesNotifier();
  },
);
