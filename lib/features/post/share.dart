import 'package:flutter/material.dart';

class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ShareState();
  }
}

class _ShareState extends State<Share> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crosspost'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text("Post"),
            ),
          ],
        ),
        body: Column(children: [
          
        ],),
      ),
    );
  }
}
