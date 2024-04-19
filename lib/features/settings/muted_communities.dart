import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
                    Text('Posts from muted communities will not show up in'),
                    Text('your feeds or recommendations.'),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextField(
                controller: _communityNameController,
                decoration: InputDecoration(
                  hintText: 'Search Communities',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Expanded(child: ListView.builder(
              //itemCount: ,
              itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(),
                title: const Text('Community Name'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Unmute'),
                ),
              );
            }))
          ],
        ),
      ),
    );
  }
}
