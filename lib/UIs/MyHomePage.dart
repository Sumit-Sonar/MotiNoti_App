import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:motinoti_app/UIs/MotiPostsUI.dart';
import 'package:motinoti_app/UIs/MotiQuotesUI.dart';
import 'package:motinoti_app/UIs/MotiVideos.UI.dart';
import 'package:motinoti_app/UIs/ScheduleNotifyUI.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motinoti_app/services/notifiService.dart';

class MyHomePage extends StatelessWidget {
  final NotificationService notificationService;

  const MyHomePage({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan,
        appBar: AppBar(
          title: const Text("MotiNoti"),
          backgroundColor: Colors.white,
          actions: <Widget>[
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'aboutUs',
                  child: Text('About'),
                ),
              ],
              onSelected: (String choice) {
                if (choice == 'aboutUs') {
                  showAboutUsDialog(context);
                }
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bck.png',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const MotiPostsUI(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return ScaleTransition(
                                        scale: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                        child: child,
                                      );
                                    }));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white54, // Text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          child: const Text(
                            'Motivational Posts',
                            style: TextStyle(fontSize: 20),
                          ), // Button text
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const MotiQuotesUI(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return ScaleTransition(
                                        scale: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                        child: child,
                                      );
                                    }));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white54, // Text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          child: const Text(
                            'Motivational Quotes',
                            style: TextStyle(fontSize: 20),
                          ), // Button text
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const MotiVideosUI(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return ScaleTransition(
                                        scale: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                        child: child,
                                      );
                                    }));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white54, // Text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          child: const Text(
                            'Motivational Videos',
                            style: TextStyle(fontSize: 20),
                          ), // Button text
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ScheduleNotifyUI(notificationService: NotificationService(),),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return ScaleTransition(
                                        scale: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                        child: child,
                                      );
                                    }));
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white54, // Text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8), // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          child: const Text(
                            'Schedule Notify',
                            style: TextStyle(fontSize: 20),
                          ), // Button text
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void showAboutUsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("About"),
              content: RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text:
                        "This app is developed for the people who needs motivation while they lost in their phone(keep scrolling)\n\n",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                const TextSpan(
                    text: "Developer - ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "sonar02sumit@gmail.com",
                    style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch("mailto:sonar02sumit@gmail.com");
                      }),
              ])));
        });
  }
}
