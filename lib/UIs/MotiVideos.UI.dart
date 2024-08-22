import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:motinoti/services/adsServices.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MotiVideosUI extends StatefulWidget {
  const MotiVideosUI({super.key});

  @override
  State<MotiVideosUI> createState() => _MotiVideosUIState();
}

class _MotiVideosUIState extends State<MotiVideosUI> {
  final String apiKey = 'AIzaSyBZ_LedH8CzZKBRqpWbtZPPkpGX5QFmEJQ';
  final String searchQuery = 'new motivational videos';
  final int maxResults = 10;

  late Future<List<String>> _videosFuture;
  List<String> _videoIds = [];
  bool _isLoadingMore = false;
  String? _nextPageToken;
  final AdsService adsService = AdsService();

  @override
  void initState() {
    super.initState();
    _videosFuture = fetchVideos();
    adsService.loadBannerAd(context);
  }

  Future<List<String>> fetchVideos() async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&q=$searchQuery&type=video&part=snippet&maxResults=$maxResults&pageToken=${_nextPageToken ?? ''}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];
      _nextPageToken = data['nextPageToken'];
      return items.map<String>((item) => item['id']['videoId']).toList();
    } else {
      throw ("error");
    }
  }

  Future<void> _loadMoreVideos() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newVideos = await fetchVideos();
      setState(() {
        _videoIds.addAll(newVideos);
        _isLoadingMore = false;
      });
    } catch (error) {
      setState(() {
        _isLoadingMore = false;
      });
      print('Error fetching more videos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title:
            Text('Motivational Videos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _videosFuture = fetchVideos();
                _videoIds.clear();
                _nextPageToken = null;
              });
            },
          ),
        ],
      ),
      body: Stack(fit: StackFit.expand, children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.blueGrey],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        FutureBuilder<List<String>>(
          future: _videosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error loading videos. Please try again.'),
                  ),
                );
              });
              return Center(child: Text('Check your connectivity'));
            } else {
              _videoIds = snapshot.data!;
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!_isLoadingMore &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    _loadMoreVideos();
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: _videoIds.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _videoIds.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      height: 600,
                      padding: const EdgeInsets.all(8.0),
                      child: WebView(
                        initialUrl:
                            'https://www.youtube.com/embed/${_videoIds[index]}?autoplay=1',
                        javascriptMode: JavascriptMode.unrestricted,
                        onPageFinished: (String url) {
                          print('Page finished loading: $url');
                        },
                        onWebResourceError: (error) {
                          print('Error loading video: $error');
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ]),
      bottomNavigationBar: adsService.isbannerAdLoaded
          ? Container(
              color: Colors.transparent,
              width: adsService.bannerAd!.size.width.toDouble(),
              height: adsService.bannerAd!.size.height.toDouble(),
              alignment: Alignment.center,
              child: AdWidget(ad: adsService.bannerAd!),
            )
          : SizedBox.shrink(),
    );
  }
}
