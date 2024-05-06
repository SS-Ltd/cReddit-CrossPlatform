import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  final List<String> rules;
  final List<String> moderators;
  final String description;
  final String subredditName;
  final String bannerURL;
  const RulesPage(
      {super.key,
      required this.rules,
      required this.description,
      required this.subredditName,
      required this.bannerURL,
      required this.moderators});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('r/$subredditName',
            style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  bannerURL), // Replace with your subreddit banner URL
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Description',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text(description, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Text(
                      'Subreddit Rules',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rules.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${index + 1}. ${rules[index]}',
                            style: const TextStyle(fontSize: 14)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Text(
                      'Moderators',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: moderators.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${index + 1}. ${moderators[index]}',
                            style: const TextStyle(fontSize: 14)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
