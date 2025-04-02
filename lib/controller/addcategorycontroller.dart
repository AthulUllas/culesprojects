import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:culesprojects/models/categorymodel.dart';

final supabase = Supabase.instance.client;

class ServicesNotifier extends AsyncNotifier<List<Service>> {
  @override
  Future<List<Service>> build() async {
    return await fetchServices();
  }

  Future<List<Service>> fetchServices() async {
    try {
      final response = await supabase.from('data_base').select();
      return response.map<Service>((json) => Service.fromJson(json)).toList();
    } catch (error) {
      throw Exception("Failed to fetch services: $error");
    }
  }

  Future<void> addService(
    String name,
    List<Map<String, dynamic>> details,
  ) async {
    try {
      await supabase.from('data_base').insert({
        "name": name,
        "details": details,
      });

      state = AsyncData(await fetchServices());
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await supabase.from('data_base').delete().match({'id': id});

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
      final response =
          await supabase
              .from('data_base')
              .select('details')
              .eq('id', id)
              .single();

      List<Map<String, dynamic>> currentDetails =
          List<Map<String, dynamic>>.from(response['details']);

      currentDetails.add(newDetail);

      await supabase
          .from('data_base')
          .update({'details': currentDetails})
          .match({'id': id});

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
      final response =
          await supabase
              .from('data_base')
              .select('details')
              .eq('id', id)
              .single();

      List<Map<String, dynamic>> currentDetails =
          List<Map<String, dynamic>>.from(response['details']);

      currentDetails.removeWhere((detail) => _isEqual(detail, detailToRemove));

      await supabase
          .from('data_base')
          .update({'details': currentDetails})
          .match({'id': id});

      state = AsyncData(await fetchServices());
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  bool _isEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    return a.toString() == b.toString(); // Simple comparison method
  }
}

final servicesProvider = AsyncNotifierProvider<ServicesNotifier, List<Service>>(
  () {
    return ServicesNotifier();
  },
);
