import 'package:flutter/material.dart';
import 'user_comment.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _controller = TextEditingController();
  List<UserComment> _comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
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
            left: 10.0,
            right: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.red)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 40, 39, 39),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _comments.add(UserComment(
                      avatar: 'assets/MonkeyDLuffy.png',
                      username: 'User123',
                      content: _controller.text,
                      timestamp: DateTime.now(),
                    ));
                    _controller.clear();
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
