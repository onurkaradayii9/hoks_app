import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    tz.initializeTimeZones();
    await _plugin.initialize(initSettings);
  }

  static Future<void> scheduleReminder(DateTime targetDate) async {
    final androidDetails = AndroidNotificationDetails(
      'hok_channel',
      'HOK Regl Hatırlatıcı',
      importance: Importance.high,
      priority: Priority.high,
    );
    final scheduled = tz.TZDateTime.from(targetDate.subtract(const Duration(days: 2)), tz.local);

    await _plugin.zonedSchedule(
      0,
      'Döngü Hatırlatıcısı',
      'Adet döneminiz yaklaşıyor 🌸',
      scheduled,
      NotificationDetails(android: androidDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}