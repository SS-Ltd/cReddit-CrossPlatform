import 'package:flutter/material.dart';

class MutedCommunities extends StatefulWidget {
  const MutedCommunities({super.key});

  @override
  State<MutedCommunities> createState() {
    return _MutedCommunitiesState();
  }
}

class _MutedCommunitiesState extends State<MutedCommunities> {
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
      ),
    );
  }
}
