import 'package:flutter/material.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';
import 'package:reddit_clone/models/community.dart';
import 'community_card.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
/// This class represents the community page in the application.
/// It is a stateful widget that fetches a list of communities and displays them in a ListView.
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  CommunityPageState createState() => CommunityPageState();
}

/// The state class for the [CommunityPage] widget.
/// It manages the state of the widget and fetches the list of communities.
class CommunityPageState extends State<CommunityPage> {
  late Future<List<Community>> communities;

  @override
  void initState() {
    super.initState();
    communities = fetchCommunities();
  }

  /// Fetches the list of communities from the network service.
  /// Returns a future that resolves to a list of [Community] objects.
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
          return CustomLoadingIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            backgroundColor: Palette.communityPage,
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubRedditPage(
                          subredditName: snapshot.data![index].name,
                        ),
                      ),
                    );
                  },
                  child: CommunityCard(
                    community: snapshot.data![index],
                    search: false,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
