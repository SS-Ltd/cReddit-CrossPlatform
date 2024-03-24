import 'package:flutter/material.dart';

class CommentPostPage extends StatelessWidget {
  final _controller = TextEditingController();
  final String commentContent;

  CommentPostPage({super.key ,required this.commentContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add comment',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Roboto',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Post',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                Navigator.pop(context, _controller.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please enter a comment'),
                    duration: const Duration(seconds: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                commentContent,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey, thickness: 0.15),
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Your comment',
                hintStyle: TextStyle(
                    fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
