import 'package:flutter/material.dart';

class CommunityType extends StatefulWidget {
  const CommunityType({super.key});

  @override
  State<CommunityType> createState() {
    return _CommunityTypeState();
  }
}

class _CommunityTypeState extends State<CommunityType> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Community Type'),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
