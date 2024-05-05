import 'package:flutter/material.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  const EditPost({super.key, required this.postId});

  final String postId;

  @override
  State<EditPost> createState() {
    return _EditPostState();
  }
}

class _EditPostState extends State<EditPost> {

  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Edit Post'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              bool isEdited = await context.read<NetworkService>().editTextPost(
                widget.postId,
                _bodyController.text,
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Column(children: [
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(
              hintText: 'Your text post',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          )
      ],)
    );
  }
}
