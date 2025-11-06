import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataManager {
  static const String boxName = "hokReglBox";

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Box get _box => Hive.box(boxName);

  static List<DateTime> get periods {
    final list = _box.get("periods", defaultValue: <String>[]);
    return (list as List).map((e) => DateTime.parse(e)).toList();
  }

  static void addPeriod(DateTime date) {
    final list = periods..add(date);
    _box.put("periods", list.map((e) => e.toIso8601String()).toList());
  }

  static void addNote(String note) {
    final notes = List<String>.from(_box.get("notes", defaultValue: []));
    notes.add(note);
    _box.put("notes", notes);
  }

  static List<String> get notes =>
      List<String>.from(_box.get("notes", defaultValue: []));

  static int get averageCycle {
    final p = periods;
    if (p.length < 2) return 28;
    List<int> diffs = [];
    for (int i = 1; i < p.length; i++) {
      diffs.add(p[i].difference(p[i - 1]).inDays);
    }
    return diffs.reduce((a, b) => a + b) ~/ diffs.length;
  }
}