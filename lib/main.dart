import 'package:flutter/material.dart';
import 'package:motinoti_app/UIs/MotiQuotesUI.dart';
import 'package:motinoti_app/UIs/MyHomePage.dart';
import 'package:motinoti_app/services/notifiService.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(MyApp(notificationService: NotificationService()));
}

class MyApp extends StatefulWidget {
  final NotificationService notificationService;

  const MyApp({Key? key, required this.notificationService}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.notificationService.initNotification(context,
        notificationService: widget.notificationService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            MyHomePage(notificationService: widget.notificationService),
        '/MotiQuotesUI': (context) => MotiQuotesUI(),
      },
    );
  }
}
