import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MotiVideosUI extends StatefulWidget {
  const MotiVideosUI({super.key});

  @override
  State<MotiVideosUI> createState() => _MotiVideosUIState();
}

class _MotiVideosUIState extends State<MotiVideosUI> {
  final String apiKey =
      'AIzaSyBZ_LedH8CzZKBRqpWbtZPPkpGX5QFmEJQ'; // Replace with your actual API key
  final String searchQuery = 'motivational videos'; // Improved search query
  final int maxResults = 10;

  late Future<List<String>> _videosFuture;
  List<String> _videoIds = [];
  bool _isLoadingMore = false;
  String? _nextPageToken;

  @override
  void initState() {
    super.initState();
    _videosFuture = fetchVideos();
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
      throw Exception('Failed to load videos');
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
        title: Text('MotiVideos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
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
      body: FutureBuilder<List<String>>(
        future: _videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No videos found'));
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
    );
  }
}
