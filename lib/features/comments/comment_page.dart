// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/common/block_pop_up.dart';
import 'package:reddit_clone/features/User/report_button.dart';
import 'package:reddit_clone/features/comments/comment_post.dart';
import 'package:reddit_clone/features/home_page/home_page.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';
import 'user_comment.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/home_page/rightsidebar.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';

/// This file contains the [CommentPage] widget, which is a stateful widget that
/// displays a page for viewing and interacting with comments on a post.
/// The widget takes in several required parameters including [postId], [postComment],
/// [postTitle], and [username].
///
/// The [CommentPage] widget has a state, [_CommentPageState],
/// which manages the state of the widget.
/// It initializes a [TextEditingController] for handling user input,
/// and maintains a list of comments,
/// [_comments], a scroll controller, [_scrollController],
/// and lists of global keys and
/// comment positions for tracking comment positions on the page.
///
/// The [CommentPage] widget fetches comments for the specified post using the
/// [fetchComments] method, which makes a network request to retrieve.
/// The fetched comments are then mapped to [UserComment]
///  objects and stored in the [_comments] list.
///
/// The widget also provides methods for mapping votes,
/// calculating comment positions, and scrolling to the next comment.
///
/// The [CommentPage] widget builds a [Scaffold] with an [AppBar],
/// a [ListView.builder] for displaying the comments,
/// and a bottom navigation bar with a text input field for adding new comments.
/// The comments are displayed using the [UserComment] widget,
/// which takes in a [GlobalKey] to track its position on the page.
///
/// The widget also includes a [PopupMenuButton] in the app bar for displaying
/// additional options, such as sharing and subscribing to the post.
///
/// Overall, the [CommentPage] widget provides a user interface for viewing
/// and interacting with comments on a post.
class CommentPage extends StatefulWidget {
  final String postId;
  final Post postComment;
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
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    print(widget.postComment.postModel.isModerator);
    super.initState();
    fetchComments(widget.postId).then((_) {
      for (var i = 0; i < _comments.length; i++) {
        _keys.add(GlobalKey());
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateCommentPositions();
      });
      isLoading = false;
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
        _comments = fetchedComments
            .map((comment) => UserComment(
                  photo: comment.isImage ? File(comment.content) : null,
                  imageSource: 0,
                  hasVoted:
                      mappingVotes(comment.isUpvoted, comment.isDownvoted),
                  isPostPage: true,
                  comment: comment,
                  isModerator: widget.postComment.postModel.isModerator,
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
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            if (isSearching) {
              setState(() {
                isSearching = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Comments',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  contentPadding: const EdgeInsets.all(10),
                ),
                // onChanged: (value) async {
                //   setState(() {
                //     searchQuery = value;
                //   });
                //   commentsResults =
                //       await Provider.of<NetworkService>(context, listen: false)
                //           .getSearchComments(value, '');
                //   postsResults =
                //       await Provider.of<NetworkService>(context, listen: false)
                //           .getSearchPosts(value, '');
                //},
              )
            : null,
        actions: isSearching
            ? null
            : [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
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
                  },
                ),
                IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  icon: const Icon(Icons.reddit, size: 30.0),
                ),
              ],
      ),
      endDrawer: isSearching ? null : const Rightsidebar(),
      body: Builder(
        builder: (BuildContext listViewContext) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: isLoading ? 2 : _comments.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return widget.postComment;
              } else if (isLoading) {
                return CustomLoadingIndicator();
              } else if (index - 1 < _keys.length) {
                return UserComment(
                  key: _keys[index - 1],
                  photo: _comments[index - 1].photo,
                  imageSource: _comments[index - 1].imageSource,
                  hasVoted: _comments[index - 1].hasVoted,
                  comment: _comments[index - 1].comment,
                  isModerator: _comments[index - 1].isModerator,
                  isPostPage: true,
                  onDeleted: () {
                    setState(() {
                      _comments.removeAt(index - 1);
                      _keys.removeAt(index - 1);
                    });
                  },
                  onBlock: () {
                    setState(() {
                      _comments[index - 1].comment.username = "Blocked User";
                      //_comments[index - 1].isMinimized = ValueNotifier<bool>(true);
                    });
                  },
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
                        //final String commentText = result['content'];
                        newComment = UserComment(
                          photo: null,
                          imageSource: 2,
                          hasVoted: 1,
                          isPostPage: true,
                          isModerator: widget.postComment.postModel.isModerator,
                          comment: Comments(
                            profilePicture: result['user'].profilePicture,
                            username: result['user'].username,
                            isImage: contentType,
                            netVote: 1,
                            content: result['content'],
                            createdAt: DateTime.now().toString(),
                            commentId: result['commentId'],
                          ),
                        );
                      } else if (contentType == true) {
                        //final File commentImage = result['content'];
                        newComment = UserComment(
                          photo: result['content'],
                          imageSource: 1,
                          hasVoted: 1,
                          isPostPage: true,
                          isModerator: widget.postComment.postModel.isModerator,
                          comment: Comments(
                            profilePicture: result['user'].profilePicture,
                            username: result['user'].username,
                            isImage: contentType,
                            netVote: 1,
                            content: '',
                            createdAt: DateTime.now().toString(),
                            commentId: result['commentId'],
                          ),
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
                child: Semantics(
                  identifier: 'Add a comment',
                  label: 'Add a comment',
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
    bool isPostSaved = widget.postComment.postModel.isSaved;
    return <PopupMenuEntry<Menu>>[
      if (widget.username == context.read<NetworkService>().user?.username)
        const PopupMenuItem<Menu>(
          value: Menu.share,
          child: ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
          ),
        ),
      const PopupMenuItem<Menu>(
          value: Menu.subscribe,
          child: ListTile(
            leading: Icon(Icons.add_alert),
            title: Text('Subscribe'),
          )),
      PopupMenuItem<Menu>(
        value: Menu.save,
        child: ListTile(
          leading: isPostSaved
              ? const Icon(Icons.bookmark_add)
              : const Icon(Icons.bookmark_add_outlined),
          title: isPostSaved ? const Text('Unsave') : const Text("Save"),
          onTap: () async {
            print('save button clicked');
            print(isPostSaved);
            print('save button clicked');
            print(widget.postComment.postModel.isSaved);
            print(widget.postComment.postModel.postId);
            bool isSaved = await context
                .read<NetworkService>()
                .saveandunsavepost(widget.postComment.postModel.postId,
                    !(widget.postComment.postModel.isSaved));
            if (isSaved == true &&
                widget.postComment.postModel.isSaved == false) {
              setState(() {
                isPostSaved = !isPostSaved;
              });
              CustomSnackBar(
                      content: "Post saved!",
                      context: context,
                      backgroundColor: Colors.green)
                  .show();
            } else if (isSaved == true &&
                widget.postComment.postModel.isSaved == true) {
              setState(() {
                isPostSaved = !isPostSaved;
              });
              CustomSnackBar(
                      content: "Post unsaved!",
                      context: context,
                      backgroundColor: Colors.white,
                      textColor: Colors.black)
                  .show();
            }
          },
        ),
      ),
      const PopupMenuItem<Menu>(
          value: Menu.copytext,
          child: ListTile(
            leading: Icon(Icons.copy),
            title: Text('Copy text'),
          )),
      if (widget.username == context.read<NetworkService>().user?.username)
        const PopupMenuItem<Menu>(
            value: Menu.edit,
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
            )),
      // if (widget.username == context.read<NetworkService>().user?.username)
      //   const PopupMenuItem<Menu>(
      //       value: Menu.addpostflair,
      //       child: ListTile(
      //         leading: Icon(Icons.add),
      //         title: Text('Add post flair'),
      //       )),
      if (widget.username == context.read<NetworkService>().user?.username)
        const PopupMenuItem<Menu>(
            value: Menu.markspoiler,
            child: ListTile(
              leading: Icon(Icons.warning),
              title: Text('Mark spoiler'),
            )),
      if (widget.username == context.read<NetworkService>().user?.username)
        const PopupMenuItem<Menu>(
            value: Menu.markNSFW,
            child: ListTile(
              leading: Icon(Icons.warning),
              title: Text('Mark NSFW'),
            )),
      if (widget.username == context.read<NetworkService>().user?.username)
        const PopupMenuItem<Menu>(
            value: Menu.markasbrandaffiliate,
            child: ListTile(
              leading: Icon(Icons.warning),
              title: Text('Mark as brand affiliate'),
            )),
      if (widget.username == context.read<NetworkService>().user?.username)
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
          child: ReportButton(
            isPost: true,
            postId: widget.postId,
            subredditName: widget.postComment.postModel.communityName,
          )),
      PopupMenuItem<Menu>(
          value: Menu.block,
          child: ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Block Account'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlockPopUp(
                        userName: widget.postComment.postModel.username);
                  });
              // bool isBlocked = await context
              //     .read<NetworkService>()
              //     .blockUser(widget.postComment.postModel.username);
            },
          )),
      PopupMenuItem<Menu>(
          value: Menu.hide,
          child: ListTile(
            leading: const Icon(Icons.hide_source),
            title: const Text('hide'),
            onTap: () async {
              print('button clicked');
              bool isHidden = await context
                  .read<NetworkService>()
                  .hidepost(widget.postId, true);
              if (isHidden) {
                CustomSnackBar(
                        content: "Post hidden!",
                        context: context,
                        backgroundColor: Colors.white,
                        textColor: Colors.black)
                    .show();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              }
            },
          )),
    ];
  }
}

enum Menu {
  share,
  subscribe,
  save,
  copytext,
  edit,
  addpostflair,
  markspoiler,
  markNSFW,
  markasbrandaffiliate,
  delete,
  report,
  block,
  hide,
}
