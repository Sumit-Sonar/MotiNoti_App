import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:motinoti_app/UIs/MotiPostsUI.dart';
import 'package:motinoti_app/UIs/MotiQuotesUI.dart';
import 'package:motinoti_app/UIs/MotiVideos.UI.dart';
import 'package:motinoti_app/UIs/ScheduleNotifyUI.dart';
import 'package:motinoti_app/services/adsServices.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motinoti_app/services/notifiService.dart';

class MyHomePage extends StatefulWidget {
  final NotificationService notificationService;

  const MyHomePage({super.key, required this.notificationService});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AdsService adsService = AdsService();

  @override
  void initState() {
    super.initState();
    adsService.loadRewardAds(context);
    adsService.loadBannerAd(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MotiNoti",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
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
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.blueGrey[900]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildCustomButton(
                  context,
                  title: 'Motivational Posts',
                  targetPage: const MotiPostsUI(),
                  icon: Icons.photo,
                ),
                const SizedBox(height: 20),
                buildCustomButton(
                  context,
                  title: 'Motivational Quotes',
                  targetPage: const MotiQuotesUI(),
                  icon: Icons.format_quote,
                ),
                const SizedBox(height: 20),
                buildCustomButton(
                  context,
                  title: 'Motivational Videos',
                  targetPage: const MotiVideosUI(),
                  icon: Icons.video_library,
                ),
                const SizedBox(height: 20),
                buildCustomButton(
                  context,
                  title: 'Schedule Notify',
                  targetPage: ScheduleNotifyUI(
                      notificationService: widget.notificationService),
                  icon: Icons.schedule,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: adsService.isbannerAdLoaded
                  ? Container(
                      color: Colors.black,
                      child: AdWidget(ad: adsService.bannerAd!),
                      width: adsService.bannerAd!.size.width.toDouble(),
                      height: adsService.bannerAd!.size.height.toDouble(),
                      alignment: Alignment.bottomCenter,
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomButton(BuildContext context,
      {required String title,
      required Widget targetPage,
      required IconData icon}) {
    return ElevatedButton(
      onPressed: () {
        showAdAndNavigate(context, targetPage);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: Colors.black,
        elevation: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void showAdAndNavigate(BuildContext context, Widget targetPage) {
    if (adsService.rewardedAd != null) {
      adsService.rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        setState(() {
          adsService.rewardedAd!.dispose();
          adsService.loadRewardAds(context);
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  targetPage,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                  child: child,
                );
              },
            ),
          );
        });
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        setState(() {
          adsService.rewardedAd!.dispose();
          adsService.loadRewardAds(context);
        });
      });

      adsService.rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        // User earned reward.
      });
    } else {
      // If the ad isn't ready, navigate directly.
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => targetPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
              child: child,
            );
          },
        ),
      );
    }
  }

  void showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("About"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "This app is developed for people who need motivation while they get lost in their phones (endless scrolling).",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "Developer - ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    launch("mailto:sonar02sumit@gmail.com");
                  },
                  child: Text(
                    "sonar02sumit@gmail.com",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.black54,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
