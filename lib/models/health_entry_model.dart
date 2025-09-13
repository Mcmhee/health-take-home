import 'package:hive/hive.dart';

part 'health_entry_model.g.dart';

@HiveType(typeId: 1)
class HealthEntryModel extends HiveObject {
  @HiveField(0)
  String id; // Supabase id (uuid)

  @HiveField(1)
  String userId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String mood;

  @HiveField(4)
  String? note;

  @HiveField(5)
  bool isSynced; // for offline sync

  HealthEntryModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.mood,
    this.note,
    this.isSynced = false,
  });
}
