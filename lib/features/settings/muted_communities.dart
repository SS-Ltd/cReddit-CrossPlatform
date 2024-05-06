import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

/// A widget that allows users to view and manage muted communities.
class MutedCommunities extends StatefulWidget {
  const MutedCommunities({super.key});

  @override
  State<MutedCommunities> createState() {
    return _MutedCommunitiesState();
  }
}

/// The state of the [MutedCommunities] widget.
class _MutedCommunitiesState extends State<MutedCommunities> {
  final _communityNameController = TextEditingController();
  List<SearchCommunities> communitiesResults = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<NetworkService>().getUserSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomLoadingIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final settings = context.read<NetworkService>().userSettings;
            return Dialog.fullscreen(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Muted communities'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                                'Posts from muted communities will not show up in'),
                            Text('your feeds or recommendations.'),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: TextField(
                        controller: _communityNameController,
                        decoration: InputDecoration(
                          hintText: 'Search Communities',
                          suffixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                        onChanged: (value) async {
                          if (!mounted) return;
                          if (value.isEmpty) {
                            setState(() {
                              communitiesResults.clear();
                            });
                            return;
                          }
                          communitiesResults =
                              await Provider.of<NetworkService>(context,
                                      listen: false)
                                  .getSearchCommunities(value, true);
                        },
                        onTap: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                      ),
                    ),
                    isSearching
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.builder(
                                itemCount: communitiesResults.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          communitiesResults[index].icon),
                                    ),
                                    title: Text(communitiesResults[index].name),
                                    trailing: ElevatedButton(
                                      onPressed: () async {
                                        bool blocked = await context
                                            .read<NetworkService>()
                                            .muteCommunity(
                                                communitiesResults[index].name);
                                        if (blocked) {
                                          CustomSnackBar(
                                                  context: context,
                                                  content:
                                                      "Community has been muted",
                                                  backgroundColor: Colors.green)
                                              .show();
                                        }
                                      },
                                      child: const Text("Mute"),
                                    ),
                                  );
                                },
                              )
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: settings!
                                  .safetyAndPrivacy.mutedCommunities.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(settings
                                        .safetyAndPrivacy
                                        .mutedCommunities[index]
                                        .profilePicture),
                                  ),
                                  title: Text(settings.safetyAndPrivacy
                                      .mutedCommunities[index].name),
                                  trailing: ElevatedButton(
                                    onPressed: () async {
                                      bool unMuted = await context
                                          .read<NetworkService>()
                                          .unmuteCommunity(settings
                                              .safetyAndPrivacy
                                              .mutedCommunities[index]
                                              .name);
                                      if (unMuted) {
                                        setState(() {
                                          settings
                                              .safetyAndPrivacy.mutedCommunities
                                              .removeAt(index);
                                        });
                                      }
                                    },
                                    child: const Text('Unmute'),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
