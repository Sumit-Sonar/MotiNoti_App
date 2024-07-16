// Used Unsplashed Api
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MotiPostsUI extends StatefulWidget {
  const MotiPostsUI({Key? key}) : super(key: key);

  @override
  State<MotiPostsUI> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MotiPostsUI> {
  String imageUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  Future<void> fetchImage() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.unsplash.com/photos/random?query=motivation&orientation=portrait'),
        headers: {
          'Authorization':
              'Client-ID yzz3CvPBk3SsjfBkzYDu6hAnElrYX2N92nbdLVfHeXM'
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          imageUrl = result['urls']['regular'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(color: Colors.black, child: Text("MotiPosts")),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/postbck.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
          Center(
            child: isLoading
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                          0.5), // Semi-transparent black background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(), // Progress indicator
                  )
                : SizedBox.shrink(), // Hide indicator when loading is complete
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              width: 370,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: fetchImage,
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
