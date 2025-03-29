import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final listNotifierProvider =
    StateNotifierProvider<ListNotifier, AsyncValue<List<String>>>((ref) {
      return ListNotifier();
    });

class ListNotifier extends StateNotifier<AsyncValue<List<String>>> {
  ListNotifier() : super(const AsyncValue.data([])) {
    loadData();
  }

  final _supabase = Supabase.instance.client;
  final String tableName = 'my_table';

  // ✅ Load data from Supabase
  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final response = await _supabase.from(tableName).select();
      if (response.isNotEmpty) {
        // Take the first row's values (since it's a single list)
        final List<String> values = List<String>.from(response.first['values']);
        state = AsyncValue.data(values);
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // ✅ Add a new item to the list
  Future<void> addItem(String newItem) async {
    try {
      final currentValues = state.value ?? [];
      final updatedValues = [...currentValues, newItem];

      if (currentValues.isEmpty) {
        // Insert new row if the table is empty
        await _supabase.from(tableName).insert({'values': updatedValues});
      } else {
        // Update existing row if data already exists
        await _supabase
            .from(tableName)
            .update({'values': updatedValues})
            .eq(
              'id',
              (await _supabase.from(tableName).select('id')).first['id'],
            );
      }

      state = AsyncValue.data(updatedValues);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // ✅ Delete an item from the list
  Future<void> deleteItem(String item) async {
    try {
      final currentValues = state.value ?? [];
      final updatedValues =
          currentValues.where((value) => value != item).toList();

      if (updatedValues.isEmpty) {
        // Delete the row if the list is empty after removal
        await _supabase
            .from(tableName)
            .delete()
            .eq(
              'id',
              (await _supabase.from(tableName).select('id')).first['id'],
            );
      } else {
        // Update the row if data still exists
        await _supabase
            .from(tableName)
            .update({'values': updatedValues})
            .eq(
              'id',
              (await _supabase.from(tableName).select('id')).first['id'],
            );
      }

      state = AsyncValue.data(updatedValues);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
