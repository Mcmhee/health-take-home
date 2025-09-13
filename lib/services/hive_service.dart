import 'package:health_tracker/models/health_entry_model.dart';
import 'package:health_tracker/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  static const String _usersBox = 'users_box';
  static const String _entriesBox = 'entries_box';

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HealthEntryModelAdapter().typeId)) {
      Hive.registerAdapter(HealthEntryModelAdapter());
    }

    await Future.wait([
      Hive.openBox<UserModel>(_usersBox),
      Hive.openBox<HealthEntryModel>(_entriesBox),
    ]);
  }

  //
  Box<UserModel> get _userBox => Hive.box<UserModel>(_usersBox);

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('current_user', user);
  }

  UserModel? getUser() => _userBox.get('current_user');

  Future<void> deleteUser() async {
    await _userBox.delete('current_user');
  }

  //
  Box<HealthEntryModel> get _entryBox =>
      Hive.box<HealthEntryModel>(_entriesBox);

  Future<void> addEntry(HealthEntryModel entry) async {
    if (entry.id == null) {
      throw ArgumentError('HealthEntryModel.id cannot be null when saving');
    }
    await _entryBox.put(entry.id, entry);
  }

  List<HealthEntryModel> getAllEntries() {
    final entries = _entryBox.values.toList();
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<void> saveAllEntries(List<HealthEntryModel> entries) async {
    await _entryBox.clear();
    for (var entry in entries) {
      if (entry.id == null) continue;
      await _entryBox.put(entry.id, entry);
    }
  }

  Future<void> deleteEntry(String id) async {
    await _entryBox.delete(id);
  }

  Future<void> clearAll() async {
    await _userBox.clear();
    await _entryBox.clear();
  }
}
