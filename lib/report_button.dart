import 'package:flutter/material.dart';

class ReportButton extends StatefulWidget {
  @override
  _ReportButtonState createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  String? selectedReason;

  void showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              color: Color.fromRGBO(34, 34, 34, 1),
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(bc).viewInsets.bottom),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Submit a Report',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Help fellow redditors by reporting things that break the rules. Let us know what's happening, and we'll look into it.",
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
                            child: Text('Next', style: TextStyle(fontSize: 17)),
                            onPressed: () {
                              if (selectedReason != null) {
                                print(
                                    'Report submitted for reason: $selectedReason');
                              }
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
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
        title: Text('Report Button Page'),
        backgroundColor: Color.fromRGBO(16, 16, 16, 1),
      ),
      body: Center(
        child: ListTile(
          tileColor: Color.fromRGBO(34, 34, 34, 1),
          leading: Icon(Icons.flag, color: Colors.white),
          title: Text(
            'Report',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () => showReportSheet(context),
        ),
      ),
    );
  }
}
