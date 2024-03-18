import 'package:flutter/material.dart';
import 'package:reddit_clone/block_button.dart';

void main() {
  runApp(MaterialApp(
    home: BlockButtonDemo(),
  ));
}

class BlockButtonDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block Button Demo'),
      ),
      backgroundColor: Color.fromARGB(255, 32, 98, 197),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlockButton(
              isCircular: true,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => BlockConfirmationDialog(),
                );
              },
            ),
            SizedBox(height: 20.0),
            BlockButton(
              isCircular: false,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => BlockConfirmationDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
