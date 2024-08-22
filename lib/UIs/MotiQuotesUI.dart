import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:motinoti/services/adsServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MotiQuotesUI extends StatefulWidget {
  const MotiQuotesUI({super.key});

  @override
  State<MotiQuotesUI> createState() => _MotiQuotesUIState();
}

class _MotiQuotesUIState extends State<MotiQuotesUI> with SingleTickerProviderStateMixin {
  late Future<Map<String, String>> futureQuote;
  String apiUrl =
      'https://zenquotes.io/api/quotes/3df4c8bc385b60f0c0bc573582ef65df';
  bool isLoading = false;
  final AdsService adsService = AdsService();
  double initialY = 0.0;
  late AnimationController animationController;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    adsService.loadBannerAd(context);
    futureQuote = fetchQuote();
    checkAndShowUserGuide();
    
    // Initialize AnimationController
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Define the animation for the opacity of the quote
    opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<Map<String, String>> fetchQuote() async {
    const int maxRetries = 5;
    int retryCount = 0;
    int retryDelay = 1000; // Start with 1 second

    while (retryCount < maxRetries) {
      try {
        final response = await http.get(
          Uri.parse(apiUrl),
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          final Map<String, String> quoteData = {
            'quote': data[0]['q'],
            'author': data[0]['a'],
          };
          return quoteData;
        } else if (response.statusCode == 429) {
          retryCount++;
          await Future.delayed(Duration(milliseconds: retryDelay));
          retryDelay *= 2; // Exponential backoff
        } else {
          throw Exception(
              'Failed to load quote. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching quote: $e');
        if (retryCount >= maxRetries) {
          throw e;
        }
      }
    }

    throw Exception('Failed to load quote after multiple retries.');
  }

  Future<void> checkAndShowUserGuide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isGuideShown = prefs.getBool('isGuideShown');
    if (isGuideShown == null || !isGuideShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showUserGuide());
      await prefs.setBool('isGuideShown', true);
    }
  }

  void showUserGuide() {
    print('Showing user guide...');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'User Guide',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Swipe up to view more quotes.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Got it!', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "MotiQuotes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onVerticalDragStart: (details) {
          initialY = details.localPosition.dy;
        },
        onVerticalDragUpdate: (details) {
          if (initialY - details.localPosition.dy > 100) {
            setState(() {
              isLoading = true;
            });

            // Start the fade-out animation
            animationController.forward().then((_) {
              futureQuote = fetchQuote().then((value) {
                setState(() {
                  isLoading = false;
                });
                return value;
              });

              // Reset the animation
              animationController.reverse();
            });
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/motiquotesbcg.png',
              fit: BoxFit.cover,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<Map<String, String>>(
                    future: futureQuote,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          "Failed to load quote: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        );
                      } else {
                        return AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: opacityAnimation,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      snapshot.data?['quote'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "- ${snapshot.data?['author'] ?? 'Unknown'}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
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
                        color: Colors.grey,
                        child: AdWidget(ad: adsService.bannerAd!),
                        width: adsService.bannerAd!.size.width.toDouble(),
                        height: adsService.bannerAd!.size.height.toDouble(),
                        alignment: Alignment.center,
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
