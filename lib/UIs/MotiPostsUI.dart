import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:motinoti_app/services/adsServices.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MotiPostsUI extends StatefulWidget {
  const MotiPostsUI({Key? key}) : super(key: key);

  @override
  State<MotiPostsUI> createState() => _MotiPostsUIState();
}

class _MotiPostsUIState extends State<MotiPostsUI> {
  final AdsService adsService = AdsService();
  List<Map<String, String>> imagesData = []; // Store URLs and attribution data
  bool isLoading = true;
  bool hasError = false;
  double initialY = 0.0;
  final PageController _pageController = PageController();
  String quote = '';

  @override
  void initState() {
    super.initState();
    adsService.loadBannerAd(context);
    fetchImages();
    checkAndShowUserGuide();
  }

  Future<void> checkAndShowUserGuide() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isGuideShown = prefs.getBool('isGuideShown');
    if (isGuideShown == null || !isGuideShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showUserGuide());
      await prefs.setBool('isGuideShown', true);
    }
  }

  Future<void> fetchImages() async {
    const String accessKey = '5W-DnmXTdrHYzVqJ9gg8h8mHqT9vQ42wgE6Lswwtncs';
    final String query = 'Mountains'; // Use more general keywords
    final String apiUrl =
        'https://api.unsplash.com/search/photos?page=1&query=$query&orientation=portrait&client_id=$accessKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> results = jsonResponse['results'];
        if (results.isNotEmpty) {
          setState(() {
            imagesData = results
                .map<Map<String, String>>((item) => {
                      'url': item['urls']['regular'] ?? '',
                      'downloadUrl': item['links']['download_location'] ?? '',
                      'photographer': item['user']['name'] ?? '',
                      'photographerUrl': item['user']['links']['html'] ?? '',
                    })
                .toList();
            isLoading = false;
            hasError = false;
          });
        } else {
          showNoResultsError();
        }
      } else {
        showConnectivityError();
      }
    } catch (e) {
      print('Error fetching images: $e');
      showConnectivityError();
    }
  }

  void showUserGuide() {
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
              'Swipe left to view more images. Swipe down to refresh. Enter a motivational quote to personalize your image.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Got it!',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void showConnectivityError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error loading posts. Please try again."),
        duration: Duration(seconds: 4),
      ),
    );
    setState(() {
      isLoading = false;
      hasError = true;
    });
  }

  void showNoResultsError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("No results found."),
        duration: Duration(seconds: 4),
      ),
    );
    setState(() {
      isLoading = false;
      hasError = true;
    });
  }

  Future<void> triggerDownload(String downloadUrl) async {
    try {
      await http.get(
        Uri.parse(downloadUrl),
        headers: {
          'Authorization':
              'Client-ID 5W-DnmXTdrHYzVqJ9gg8h8mHqT9vQ42wgE6Lswwtncs'
        },
      );
    } catch (e) {
      print('Error triggering download: $e');
    }
  }

  void loadNextImage(int index) {
    if (index < imagesData.length) {
      triggerDownload(imagesData[index]['downloadUrl']!);
    }
    setState(() {
      isLoading = true;
      hasError = false;
    });
    fetchImages();
  }

  ScreenshotController screenshotController = ScreenshotController();
  void saveAndShareImage() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final imagePath = '$directory/motivational_post.png';

    try {
      final image =
          await screenshotController.capture(delay: Duration(milliseconds: 10));
      if (image != null) {
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(image);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Your creation has been saved!"),
        ));
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: 'Check out my motivational post!',
        );
      }
    } catch (e) {
      print('Error capturing or saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Create Motivational Quotes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.blueGrey[900]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: isLoading
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : hasError
                    ? Text(
                        'Please try again later',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                    : SizedBox.shrink(),
          ),
          if (!isLoading && !hasError && imagesData.isNotEmpty)
            GestureDetector(
              onVerticalDragStart: (details) {
                initialY = details.localPosition.dy;
              },
              onVerticalDragUpdate: (details) {
                if (initialY - details.localPosition.dy > 100) {
                  loadNextImage(_pageController.page!.toInt());
                }
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: imagesData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 70, left: 5, right: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 405,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(imagesData[index]['url']!),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                quote,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                      offset: Offset(5.0, 5.0),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Photo by ${imagesData[index]['photographer']} on Unsplash',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              // Open photographer's profile
                              launch(imagesData[index]['photographerUrl']!);
                            },
                            child: Text(
                              'View Profile',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                quote = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your motivational quote",
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: saveAndShareImage,
                            child: Text('Save & Share'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
