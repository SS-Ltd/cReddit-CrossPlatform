import 'package:flutter/material.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'community_card.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

class CommunityPage extends StatefulWidget {
  @override
  CommunityPageState createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  late Future<List<Community>> communities;

  @override
  void initState() {
    super.initState();
    communities = fetchCommunities();
  }

  Future<List<Community>> fetchCommunities() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final fetchedCommunities = await networkService.fetchTopCommunities();
    return fetchedCommunities;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Community>>(
      future: communities,
      builder: (BuildContext context, AsyncSnapshot<List<Community>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   title: const Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Icon(Icons.public, color: Palette.blueColor),
            //       SizedBox(width: 8),
            //       Text('Top Globally'),
            //     ],
            //   ),
            // ),
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return CommunityCard(
                  name: snapshot.data![index].name,
                  members: snapshot.data![index].members,
                  description: snapshot.data![index].description ?? '',
                  icon: snapshot.data![index].icon,
                  isJoined: snapshot.data![index].isJoined,
                );
              },
            ),
          );
        }
      },
    );
  }
}
