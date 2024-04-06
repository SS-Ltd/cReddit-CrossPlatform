import 'package:flutter/material.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'community_card.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/NetworkServices.dart';

class CommunityPage extends StatefulWidget {
  @override
  CommunityPageState createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  List<Community> communities = [];

  @override
  void initState() {
    super.initState();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final fetchedCommunities = await networkService.fetchTopCommunities();
    if (fetchedCommunities != null) {
      setState(() {
        communities = fetchedCommunities;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.public,color: Palette.blueColor),
            SizedBox(width: 8),
            Text('Top Globally'),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (BuildContext context, int index) {
          return CommunityCard(
            name: communities[index].name,
            members: communities[index].members,
            description: communities[index].description ?? '',
            //description : 'A community for Flutter developers to share knowledge and ask questions.',
            icon: communities[index].icon,
            isJoined: communities[index].isJoined,
          );
        },
      ),
    );
  }
}