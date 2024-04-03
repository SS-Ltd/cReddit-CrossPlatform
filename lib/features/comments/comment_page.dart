import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'user_comment.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() {
    return _CommentPageState();
  }
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _controller = TextEditingController();
  final List<UserComment> _comments = [];
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = [];
  final List<double> _commentPositions = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _comments.length; i++) {
      _keys.add(GlobalKey());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateCommentPositions();
    });
  }

  void _calculateCommentPositions() {
    for (var key in _keys) {
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;
        _commentPositions.add(position);
      }
    }
  }

  void _scrollToNextComment() {
    for (var position in _commentPositions) {
      if (position > _scrollController.offset) {
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Builder(
        builder: (BuildContext listViewContext) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              if (index < _keys.length) {
                return UserComment(
                  key: _keys[index],
                  avatar: _comments[index].avatar,
                  username: _comments[index].username,
                  content: _comments[index].content,
                  timestamp: _comments[index].timestamp,
                  photo: _comments[index].photo,
                  contentType: _comments[index].contentType,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
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
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentPostPage(
                            commentContent: 'Your comment content here')),
                  );

                  if (result != null) {
                    final bool contentType = result['contentType'];

                    setState(() {
                      if (contentType == false) {
                        final String commentText = result['content'];
                        _comments.add(UserComment(
                          avatar: 'assets/MonkeyDLuffy.png',
                          username: 'User123',
                          content: commentText,
                          timestamp: DateTime.now(),
                          photo: null,
                          contentType: contentType,
                        ));
                      } else if (contentType == true) {
                        final File commentImage = result['content'];
                        _comments.add(UserComment(
                          avatar: 'assets/MonkeyDLuffy.png',
                          username: 'User123',
                          content: '',
                          timestamp: DateTime.now(),
                          photo: commentImage,
                          contentType: contentType,
                        ));
                      }
                      // Add a GlobalKey for the new comment
                      _keys.add(GlobalKey());
                      _calculateCommentPositions();
                    });
                  }
                },
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 40, 39, 39),
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  ),
                  enabled: false, // Disable the TextFormField
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 40, 39, 39),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: Colors.grey,
                ),
                onPressed: _scrollToNextComment,
              ),
            )
          ],
        ),
      ),
    );
  }
}
