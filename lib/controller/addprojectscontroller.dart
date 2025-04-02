import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class DetailsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  String? serviceId;

  @override
  Future<List<Map<String, dynamic>>> build() async {
    if (serviceId == null) return [];
    return await fetchDetails(serviceId!);
  }

  void setServiceId(String id) {
    serviceId = id;
    ref.invalidateSelf();
  }

  Future<List<Map<String, dynamic>>> fetchDetails(String id) async {
    try {
      final response =
          await supabase
              .from('data_base')
              .select('details')
              .eq('id', id)
              .single();

      return List<Map<String, dynamic>>.from(response['details']);
    } catch (error) {
      throw Exception("Failed to fetch details: $error");
    }
  }

  Future<void> addDetail(Map<String, dynamic> newDetail) async {
    if (serviceId == null) return;

    try {
      final response =
          await supabase
              .from('data_base')
              .select('details')
              .eq('id', serviceId!)
              .single();

      List<Map<String, dynamic>> currentDetails =
          List<Map<String, dynamic>>.from(response['details']);
      currentDetails.add(newDetail);

      await supabase
          .from('data_base')
          .update({'details': currentDetails})
          .match({'id': serviceId!});

      state = AsyncData(await fetchDetails(serviceId!));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> removeDetail(Map<String, dynamic> detailToRemove) async {
    if (serviceId == null) return;

    try {
      final response =
          await supabase
              .from('data_base')
              .select('details')
              .eq('id', serviceId!)
              .single();

      if (response['details'] == null) {
        throw Exception("Service or details not found");
      }

      List<Map<String, dynamic>> currentDetails =
          List<Map<String, dynamic>>.from(response['details']);

      debugPrint("Before removal: $currentDetails");

      currentDetails.removeWhere(
        (detail) => _mapEquals(detail, detailToRemove),
      );

      debugPrint("After removal: $currentDetails");

      final updateResponse =
          await supabase
              .from('data_base')
              .update({'details': currentDetails})
              .match({'id': serviceId!})
              .select();

      if (updateResponse.isEmpty) throw Exception("Failed to update Supabase");

      debugPrint("Update Response: $updateResponse");

      state = AsyncData(await fetchDetails(serviceId!));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      debugPrint("Error removing detail: $error");
    }
  }

  bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (var key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) {
        return false;
      }
    }
    return true;
  }

  // Helper function to compare two maps
  bool isEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    return a.toString() == b.toString();
  }
}

final detailsProvider =
    AsyncNotifierProvider<DetailsNotifier, List<Map<String, dynamic>>>(() {
      return DetailsNotifier();
    });
