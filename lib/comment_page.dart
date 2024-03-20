import 'package:flutter/material.dart';
import 'package:reddit_clone/comment_post.dart';
import 'user_comment.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() {
    return _CommentPageState();
  }
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _controller = TextEditingController();
  final List<UserComment> _comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) => UserComment(
          avatar: _comments[index].avatar,
          username: _comments[index].username,
          content: _comments[index].content,
          timestamp: _comments[index].timestamp,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 10,
            top: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final commentText = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentPostPage(
                            commentContent: 'Your comment content here')),
                  );

                  if (commentText != null) {
                    _comments.add(UserComment(
                      avatar: 'assets/MonkeyDLuffy.png',
                      username: 'User123',
                      content: commentText,
                      timestamp: DateTime.now(),
                    ));
                  }
                },
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 40, 39, 39),
                    contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  ),
                  enabled: false, // Disable the TextFormField
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                // if (_controller.text.isNotEmpty) {
                //   setState(() {
                //     _comments.add(UserComment(
                //       avatar: 'assets/MonkeyDLuffy.png',
                //       username: 'User123',
                //       content: _controller.text,
                //       timestamp: DateTime.now(),
                //     ));
                //     _controller.clear();
                //   });
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
