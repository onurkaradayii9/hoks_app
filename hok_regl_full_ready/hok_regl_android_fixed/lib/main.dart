import 'package:flutter/material.dart';
import 'data_manager.dart';
import 'notification_service.dart';
import 'package:table_calendar/table_calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataManager.init();
  await NotificationService.init();
  runApp(HokReglApp());
}

class HokReglApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOK Regl',
      theme: ThemeData(
        primaryColor: Color(0xFFF8C6CF),
        scaffoldBackgroundColor: Colors.white,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFE5B0E3)),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    DashboardPage(),
    CalendarPage(),
    NotesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOK Regl", style: TextStyle(color: Color(0xFFB85C73))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFB85C73),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Takvim"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notlar"),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Hoş geldin 🌸",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                DataManager.addPeriod(DateTime.now());
                int avg = DataManager.averageCycle;
                DateTime next = DateTime.now().add(Duration(days: avg));
                await NotificationService.scheduleReminder(next);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Adet tarihi kaydedildi. Hatırlatma ayarlandı.")));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEE9FB1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text("Adet Başladı")),
          SizedBox(height: 20),
          Text("Ortalama döngü süresi: ${DataManager.averageCycle} gün"),
        ]));
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final periods = DataManager.periods;
    return Padding(
        padding: EdgeInsets.all(16),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) =>
              periods.any((p) => p.difference(day).inDays == 0),
          calendarStyle: CalendarStyle(
            todayDecoration:
                BoxDecoration(color: Color(0xFFF8C6CF), shape: BoxShape.circle),
            selectedDecoration:
                BoxDecoration(color: Color(0xFFB85C73), shape: BoxShape.circle),
          ),
        ));
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notes = DataManager.notes;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _ctrl,
            decoration:
                InputDecoration(labelText: "Yeni not", border: OutlineInputBorder()),
          ),
          SizedBox(height: 8),
          ElevatedButton(
              onPressed: () {
                if (_ctrl.text.isNotEmpty) {
                  DataManager.addNote(_ctrl.text);
                  setState(() {});
                  _ctrl.clear();
                }
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFFEE9FB1)),
              child: Text("Kaydet")),
          SizedBox(height: 20),
          Expanded(
              child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (c, i) => ListTile(
                      title: Text(notes[i]),
                      leading: Icon(Icons.favorite, color: Color(0xFFB85C73)))))
        ],
      ),
    );
  }
}