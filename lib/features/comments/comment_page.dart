import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/comments/comment_post.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';
import 'user_comment.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/home_page/rightsidebar.dart';

class CommentPage extends StatefulWidget {
  final String postId;
  final Widget postComment;
  final String postTitle;
  final String username;
  const CommentPage(
      {super.key,
      required this.postId,
      required this.postComment,
      required this.postTitle,
      required this.username});

  @override
  State<CommentPage> createState() {
    return _CommentPageState();
  }
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _controller = TextEditingController();
  List<UserComment> _comments = [];
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = [];
  final List<double> _commentPositions = [];

  //List<Comments> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments(widget.postId).then((_) {
      for (var i = 0; i < _comments.length; i++) {
        _keys.add(GlobalKey());
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateCommentPositions();
      });
    });
  }

  int mappingVotes(bool isUpvoted, bool isDownvoted) {
    if (isUpvoted) {
      return 1;
    } else if (isDownvoted) {
      return -1;
    } else {
      return 0;
    }
  }

  Future<void> fetchComments(String postId) async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final fetchedComments = await networkService.fetchCommentsForPost(postId);
    if (fetchedComments != null && mounted) {
      setState(() {
        //comments = fetchedComments;
        _comments = fetchedComments
            .map((comment) => UserComment(
                  avatar: comment.profilePicture,
                  username: comment.username,
                  content: comment.content,
                  timestamp: DateTime.parse(comment.createdAt),
                  photo: comment.isImage ? File(comment.content) : null,
                  contentType: comment.isImage,
                  netVote: comment.netVote,
                  imageSource: 0,
                  commentId: comment.commentId,
                  hasVoted:
                      mappingVotes(comment.isUpvoted, comment.isDownvoted),
                  isSaved: comment.isSaved,
                ))
            .toList();
      });
    }
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 30.0),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort, size: 30.0),
          ),
          PopupMenuButton(
              onSelected: (Menu item) {},
              itemBuilder: (BuildContext context) {
                return menuitems();
              }),
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Icons.reddit, size: 30.0),
          ),
        ],
      ),
      endDrawer: const Rightsidebar(),
      body: Builder(
        builder: (BuildContext listViewContext) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: _comments.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return widget.postComment;
              } else if (index - 1 < _keys.length) {
                return UserComment(
                  key: _keys[index - 1],
                  avatar: _comments[index - 1].avatar,
                  username: _comments[index - 1].username,
                  content: _comments[index - 1].content,
                  timestamp: _comments[index - 1].timestamp,
                  photo: _comments[index - 1].photo,
                  contentType: _comments[index - 1].contentType,
                  netVote: _comments[index - 1].netVote,
                  imageSource:
                      _comments[index - 1].imageSource, //may need to be fixed
                  commentId: _comments[index - 1].commentId,
                  hasVoted: _comments[index - 1].hasVoted,
                  isSaved: _comments[index - 1].isSaved,
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
                            postId: widget.postId,
                            commentContent: widget.postTitle)),
                  );

                  if (result != null) {
                    final bool contentType = result['contentType'];

                    setState(() {
                      UserComment? newComment;
                      if (contentType == false) {
                        final String commentText = result['content'];
                        newComment = UserComment(
                          avatar: result['user'].profilePicture,
                          username: result['user'].username,
                          content: commentText,
                          timestamp: DateTime.now(),
                          photo: null,
                          contentType: contentType,
                          imageSource: 2,
                          commentId: result['commentId'],
                          hasVoted: 1,
                          isSaved: false,
                        );
                      } else if (contentType == true) {
                        final File commentImage = result['content'];
                        newComment = UserComment(
                          avatar: result['user'].profilePicture,
                          username: result['user'].username,
                          content: '',
                          timestamp: DateTime.now(),
                          photo: commentImage,
                          contentType: contentType,
                          imageSource: 1,
                          commentId: result['commentId'],
                          hasVoted: 1,
                          isSaved: false,
                        );
                      }
                      if (newComment != null) {
                        // Insert the new comment at the beginning of the list
                        _comments.insert(0, newComment);
                        // Add a GlobalKey for the new comment
                        _keys.insert(0, GlobalKey());
                        _calculateCommentPositions();
                      }
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

  List<PopupMenuEntry<Menu>> menuitems() {
    return <PopupMenuEntry<Menu>>[
      //////////////////////////////////////////
      (widget.username != context.read<NetworkService>().user?.username)
          ? const PopupMenuItem<Menu>(
              value: Menu.share,
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
              ))
          : const PopupMenuItem(
              child: SizedBox(),
            ),
      const PopupMenuItem<Menu>(
          value: Menu.subscribe,
          child: ListTile(
            leading: Icon(Icons.add_alert),
            title: Text('Subscribe'),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.save,
          child: ListTile(
            leading: Icon(Icons.bookmark_add_outlined),
            title: Text('Save'),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.copytext,
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('Copy text'),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.edit,
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.addpostflair,
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Add post flair'),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.markspoiler,
          child: ListTile(
            leading: Icon(Icons.warning),
            title: Text('Mark spoiler'),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.markNSFW,
          child: ListTile(
            leading: Icon(Icons.warning),
            title: Text('Mark NSFW'),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.markasbrandaffiliate,
          child: ListTile(
            leading: Icon(Icons.warning),
            title: Text('Mark as brand affiliate'),
          )),
      PopupMenuItem<Menu>(
          value: Menu.delete,
          child: ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () async {
              bool isDeleted = await context
                  .read<NetworkService>()
                  .deletepost(widget.postId);
              if (isDeleted) {
                //show snackbar
              }
            },
          )),
      PopupMenuItem<Menu>(
          value: Menu.report,
          child: ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report'),
            onTap: () async {
              print(widget.postId);
              bool isReported = await context
                  .read<NetworkService>()
                  .reportPost(widget.postId);
              if (isReported) {
                //show snackbar
              }
            },
          )),

      const PopupMenuItem<Menu>(
          value: Menu.block,
          child: ListTile(
            leading: Icon(Icons.block),
            title: Text('Block'),
          )),
      PopupMenuItem<Menu>(
          value: Menu.hide,
          child: ListTile(
            leading: const Icon(Icons.hide_source),
            title: const Text('hide'),
            onTap: () async {
              bool isHidden = await context
                  .read<NetworkService>()
                  .hidepost(widget.postId, true);
              if (isHidden) {
                //show snackbar
              }
            },
          )),
    ];
  }
}

enum Menu {
  share,
  subscribe,
  save, //done
  copytext,
  edit,
  addpostflair,
  markspoiler,
  markNSFW,
  markasbrandaffiliate,
  delete, //done

  report, //done
  block,
  hide, //done
}

Widget mockPost() {
  return Column(
    children: [
      Post(
        communityName: 'Entrepreneur',
        userName: 'throwaway123',
        title: 'Escaping corporate Hell and finding freedom',
        postType: 'Normal',
        content:
            'Man, let me have a  vent for a minute. Just got out of the shittiest '
            'gig ever – being a "marketing specialist" for the supposed big boys'
            ' over at Microsoft. Let me tell you, it was not bad.',
        commentNumber: 0,
        shareNumber: 0,
        profilePicture:
            'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
        timeStamp: DateTime.now(),
        isHomePage: false,
        isSubRedditPage: false,
        postId: '1',
        votes: 0,
        isDownvoted: false,
        isUpvoted: false,
      ),
    ],
  );
}
