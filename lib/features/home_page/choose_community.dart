import 'package:flutter/material.dart';

class ChooseCommunity extends StatefulWidget {
  const ChooseCommunity({super.key});

  @override
  State<ChooseCommunity> createState() {
    return _ChooseCommunityState();
  }
}

class _ChooseCommunityState extends State<ChooseCommunity>{

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Choose a Community'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}