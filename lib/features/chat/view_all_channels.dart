import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reddit_clone/theme/palette.dart';

class ViewAllChannels extends StatelessWidget {
  final List<Map<String, dynamic>> channels;

  const ViewAllChannels({Key? key, required this.channels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Channels'),
      ),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return Card(
            color: Palette.settingsHeading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey, width: 1), // Outline
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(channel['profilePic']),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(channel['name'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(channel['subredditName'],
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                      'https://picsum.photos/200')),
                              SizedBox(width: 4),
                              CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                      'https://picsum.photos/201')),
                              SizedBox(width: 4),
                              CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                      'https://picsum.photos/202')),
                              SizedBox(width: 8),
                              Expanded(
                                child: SpinKitThreeBounce(
                                    color: Colors.grey, size: 12.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
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
