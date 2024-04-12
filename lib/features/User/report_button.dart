import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

class ReportButton extends StatefulWidget {
  const ReportButton({super.key});

  @override
  State<ReportButton> createState() {
    return _ReportButtonState();
  }
}

class _ReportButtonState extends State<ReportButton> {
  Future<http.Client> createMockHttpClient() async {
    return MockClient((request) async {
      if (request.url.path.contains('/report') && request.method == 'POST') {
        return http.Response(
            jsonEncode({"message": "Post reported successfully"}), 200);
      }
      return http.Response('Not Found', 404);
    });
  }

  String? selectedReason;

  void reportPost(String postId, String reason) async {
    final http.Client client = await createMockHttpClient();
    final response = await client.post(
      Uri.parse('/post/$postId/report'),
      body: jsonEncode({'reason': reason}),
    );

    final responseData = jsonDecode(response.body);
    print(responseData['message']);
  }

  void showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              color: const Color.fromRGBO(34, 34, 34, 1),
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(bc).viewInsets.bottom),
              child: Wrap(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Submit a Report',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Help fellow redditors by reporting things that break the"
                      " rules. Let us know what's happening, and we'll look" 
                      " into it.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  ...[
                    "Harassment",
                    "Threatening violence",
                    "Hate",
                    "Abuse",
                    "Personal information",
                    "Non-consensual"
                  ].map((reason) => ListTile(
                        title: Text(reason,
                            style: TextStyle(
                                color: selectedReason == reason
                                    ? Colors.blue
                                    : Colors.white)),
                        onTap: () {
                          setModalState(() {
                            selectedReason = reason;
                          });
                        },
                        selected: selectedReason == reason,
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedReason != null) {
                                reportPost('123', selectedReason!);
                              }
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text('Next',
                                style: TextStyle(fontSize: 17)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Button Page'),
        backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
      ),
      body: Center(
        child: ListTile(
          tileColor: const Color.fromRGBO(34, 34, 34, 1),
          leading: const Icon(Icons.flag, color: Colors.white),
          title: const Text(
            'Report',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () => showReportSheet(context),
        ),
      ),
    );
  }
}
