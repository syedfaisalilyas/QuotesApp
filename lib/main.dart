import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quotesapp/Services/Notification_Service.dart';
import 'package:quotesapp/Views/HomeScreen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  NotificationService.initialize();
  NotificationService.scheduleDailyNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quote App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
