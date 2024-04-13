import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/comments/user_comment.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/services/networkServices.dart';

class SavedComments extends StatefulWidget {
  const SavedComments({super.key});

  @override
  State<SavedComments> createState() => _SavedCommentsState();
}

class _SavedCommentsState extends State<SavedComments> {
  List<Comments>? savedComments;
  bool isLoading = false;
  int page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchSavedComments();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void fetchSavedComments() async {
    if (isLoading) return; // Prevent multiple loads
    setState(() {
      isLoading = true;
    });

    List<Comments>? newComments =
        await Provider.of<NetworkService>(context, listen: false)
            .fetchSavedComments(page: page);

    if (mounted) {
      if (newComments != null && newComments.isNotEmpty) {
        setState(() {
          savedComments = (savedComments ?? []) + newComments;
          page++; // Prepare the next page
        });
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      fetchSavedComments(); // Load more comments
    }
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

  @override
  Widget build(BuildContext context) {
    return savedComments == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: savedComments!.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < savedComments!.length) {
                return UserComment(
                  avatar: savedComments![index].profilePicture,
                  username: savedComments![index].username,
                  content: savedComments![index].content,
                  timestamp: DateTime.parse(savedComments![index].createdAt),
                  photo: savedComments![index].isImage
                      ? File(savedComments![index].content)
                      : null,
                  contentType: savedComments![index].isImage,
                  imageSource: 0,
                  commentId: savedComments![index].commentId,
                  hasVoted: mappingVotes(savedComments![index].isUpvoted,
                      savedComments![index].isDownvoted),
                  isSaved: savedComments![index].isSaved,
                  netVote: savedComments![index].netVote,
                  communityName: savedComments![index].communityName!,
                  postId: savedComments![index].postId!,
                  title: savedComments![index].title!,
                  comment: savedComments![index],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}
