// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:culesprojects/models/categorymodel.dart';

// final supabase = Supabase.instance.client;

// class SupabaseService {
//   Future<void> insertData(
//     String name,
//     List<Map<String, dynamic>> details,
//   ) async {
//     final response = await supabase.from('data_base').insert({
//       "name": name,
//       "details": details,
//     });

//     if (response.error != null) {
//       throw Exception(response.error!.message);
//     }
//   }

//   Future<List<Service>> getData() async {
//     try {
//       final response = await supabase.from('data_base').select();

//       return response.map<Service>((json) => Service.fromJson(json)).toList();
//     } catch (error) {
//       throw Exception("Failed to fetch data: $error");
//     }
//   }

//   Future<void> deleteData(String id) async {
//     final response = await supabase.from('data_base').delete().match({
//       'id': id,
//     });

//     if (response.error != null) {
//       throw Exception(response.error!.message);
//     }
//   }
// }
