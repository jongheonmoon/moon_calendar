import 'package:flutter/material.dart';
import 'package:moon_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    DateTime startDateTime = DateTime.now();
    DateTime endDateTime = DateTime.now().add(const Duration(days: 365));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Calender(
        startDateTime: startDateTime,
        selectCallback: (DateTime dateTime) {
          print(dateTime.toString());
        },
        endDateTime: endDateTime,
        disableSelectedCallback: () {
          print("선택 안되는 날짜");
        },
        isTodayColor: true,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


