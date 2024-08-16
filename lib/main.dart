import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:motinoti_app/UIs/MotiQuotesUI.dart';
import 'package:motinoti_app/UIs/MyHomePage.dart';
import 'package:motinoti_app/services/foreground_task.dart';
import 'package:motinoti_app/services/notifiService.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
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
    startForegroundTask(widget.notificationService);
    widget.notificationService.initNotification(context,
        notificationService: widget.notificationService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.grey, iconButtonTheme: IconButtonThemeData()),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            MyHomePage(notificationService: widget.notificationService),
        '/MotiQuotesUI': (context) => MotiQuotesUI(),
      },
    );
  }
}
