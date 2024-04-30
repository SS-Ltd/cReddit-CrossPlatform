import 'package:flutter/material.dart';

class PostTypes extends StatefulWidget {
  const PostTypes({Key? key}) : super(key: key);

  @override
  State<PostTypes> createState() {
    return _PostTypesState();
  }
}

class _PostTypesState extends State<PostTypes> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          title: const Text("Description"),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: const Text("Save"),
            ),
          ],
        ),
        body: Column(children: [
          
        ],),
      ),
    );
  }


  

}
