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

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final response = await _supabase.from(tableName).select();
      if (response.isNotEmpty && response.first['values'] != null) {
        final List<String> values = List<String>.from(response.first['values']);
        if (mounted) {
          state = AsyncValue.data(values);
        }
      } else {
        if (mounted) {
          state = const AsyncValue.data([]);
        }
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addItem(String newItem) async {
    try {
      final currentValues = state.value ?? [];
      final updatedValues = [...currentValues, newItem];

      if (currentValues.isEmpty) {
        await _supabase.from(tableName).insert({'values': updatedValues});
      } else {
        await _supabase
            .from(tableName)
            .update({'values': updatedValues})
            .eq(
              'id',
              (await _supabase.from(tableName).select('id')).first['id'],
            );
      }
      if (mounted) {
        state = AsyncValue.data(updatedValues);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteItem(String item) async {
    try {
      final currentValues = state.value ?? [];
      final updatedValues =
          currentValues.where((value) => value != item).toList();

      if (updatedValues.isEmpty) {
        await _supabase
            .from(tableName)
            .delete()
            .eq(
              'id',
              (await _supabase.from(tableName).select('id')).first['id'],
            );
      } else {
        await _supabase
            .from(tableName)
            .update({'values': updatedValues})
            .eq(
              'id',
              (await _supabase.from(tableName).select('id')).first['id'],
            );
      }
      if (mounted) {
        state = AsyncValue.data(updatedValues);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
