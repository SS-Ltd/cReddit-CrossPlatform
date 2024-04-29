import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:reddit_clone/services/networkServices.dart';

/// This class represents a report button widget.
///
/// The [ReportButton] widget is used to display a report button in the UI.
/// When the button is tapped, a modal bottom sheet is shown where the user can select a reason for reporting a post.
/// The selected reason is then sent to the server using an HTTP POST request.
class ReportButton extends StatefulWidget {
  final String? subredditName;
  final String? postId;
  final String? commentId;
  final bool isPost;
  const ReportButton(
      {super.key,
      this.subredditName,
      required this.isPost,
      this.postId,
      this.commentId});

  @override
  State<ReportButton> createState() {
    return _ReportButtonState();
  }
}

class _ReportButtonState extends State<ReportButton> {
  String? selectedReason;
  List<String> reasons = [
    "Harassment",
    "Threatening violence",
    "Hate",
    "Abuse",
    "Personal information",
    "Non-consensual"
  ];

  @override
  void initState() {
    super.initState();
    fetchReasons().then((value) {
      setState(() {
        reasons = value;
      });
    });
  }

  Future<List<String>> fetchReasons() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    if (widget.subredditName == null) {
      return [];
    } else {
      final details =
          await networkService.getSubredditDetails(widget.subredditName);
      return details?.rules ?? [];
    }
  }

  void report(String Id, String reason) async {
    if (widget.subredditName == null) {
      return;
    }
    final networkService = Provider.of<NetworkService>(context, listen: false);
    if (widget.isPost) {
      await networkService.reportPost(Id, reason);
    } else {
      await networkService.reportComments(Id, reason);
    }
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
                  ...reasons.map((reason) => ListTile(
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
                                report(
                                    widget.isPost
                                        ? widget.postId!
                                        : widget.commentId!,
                                    selectedReason!);
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
    return ListTile(
      leading: const Icon(Icons.flag),
      title: const Text(
        'Report',
      ),
      onTap: () => showReportSheet(context),
    );
  }
}
