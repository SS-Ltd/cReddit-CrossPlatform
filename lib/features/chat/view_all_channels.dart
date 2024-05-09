import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reddit_clone/theme/palette.dart';

class ViewAllChannels extends StatelessWidget {
  final List<Map<String, dynamic>> channels;

  const ViewAllChannels({super.key, required this.channels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Channels'),
      ),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return Card(
            color: Palette.settingsHeading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.grey, width: 1), // Outline
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(channel['profilePic']),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(channel['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(channel['subredditName'],
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                      AssetImage('assets/hehe.png')),
                              SizedBox(width: 4),
                              CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                      AssetImage('assets/hehe.png')),
                              SizedBox(width: 4),
                              CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                      AssetImage('assets/hehe.png')),
                              SizedBox(width: 8),
                              Expanded(
                                child: SpinKitThreeBounce(
                                    color: Colors.grey, size: 12.0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(channel['description']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
