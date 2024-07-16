// Used ZenQuotes Api
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MotiQuotesUI extends StatefulWidget {
  const MotiQuotesUI({super.key});

  @override
  State<MotiQuotesUI> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MotiQuotesUI> {
  late Future<Map<String, String>> futureQuote;
  String quote = '';
  String apiUrl = 'https://zenquotes.io/api/random';

  Future<Map<String, dynamic>> fetchQuote() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Map<String, String> quoteData = {
          'quote': data[0]['q'],
          'author': data[0]['a'],
        };
        return quoteData;
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      print('Error fetching quote: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Title(color: Colors.black, child: Text("MotiQuotes")),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/quotesbck.jpg',
              fit: BoxFit.cover,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                      future: fetchQuote(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            "failed to load quote ${snapshot.error}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  snapshot.data?['quote'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "- ${snapshot.data?['author'] ?? 'Unknown'}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Just to trigger rebuild
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              ),
            )
          ],
        ));
  }
}
