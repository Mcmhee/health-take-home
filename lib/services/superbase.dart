import 'package:health_tracker/models/health_entry_model.dart';
import 'package:health_tracker/models/user_model.dart';
import 'package:health_tracker/util/secret.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._internal();
  static final SupabaseService _instance = SupabaseService._internal();
  static SupabaseService get instance => _instance;

  late final SupabaseClient _client;
  SupabaseClient get client => _client;

  Future<void> init() async {
    final supabase = await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
    _client = supabase.client;
  }

  Future<UserModel?> createUser(UserModel user) async {
    final response = await _client
        .from('users')
        .insert({'id': user.id, 'name': user.name, 'device_id': user.deviceId})
        .select()
        .maybeSingle();

    return response == null
        ? null
        : UserModel(
            id: response['id'],
            name: response['name'],
            deviceId: response['device_id'],
          );
  }

  Future<UserModel?> getUserByDeviceId(String deviceId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('device_id', deviceId)
        .maybeSingle();

    return response == null
        ? null
        : UserModel(
            id: response['id'],
            name: response['name'],
            deviceId: response['device_id'],
          );
  }

  Future<HealthEntryModel?> createEntry(HealthEntryModel entry) async {
    final response = await _client
        .from('health_entries')
        .insert({
          'id': entry.id,
          'user_id': entry.userId,
          'date': entry.date.toIso8601String(),
          'mood': entry.mood,
          'note': entry.note,
        })
        .select()
        .maybeSingle();

    return response == null
        ? null
        : HealthEntryModel(
            id: response['id'],
            userId: response['user_id'],
            date: DateTime.parse(response['date']),
            mood: response['mood'],
            note: response['note'],
            isSynced: true,
          );
  }

  Future<List<HealthEntryModel>> fetchEntries(String userId) async {
    final response = await _client
        .from('health_entries')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);

    return response
        .map<HealthEntryModel>(
          (e) => HealthEntryModel(
            id: e['id'],
            userId: e['user_id'],
            date: DateTime.parse(e['date']),
            mood: e['mood'],
            note: e['note'],
            isSynced: true,
          ),
        )
        .toList();
  }
}
