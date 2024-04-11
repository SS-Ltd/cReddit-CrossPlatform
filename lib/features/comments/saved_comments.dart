import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/models/savedcomments.dart';

import 'package:reddit_clone/services/NetworkServices.dart';

class SavedComments extends StatefulWidget {
  const SavedComments({super.key});

  @override
  State<SavedComments> createState() => _SavedCommentsState();
}

class _SavedCommentsState extends State<SavedComments> {
  List<SavedCommentsModel>? savedComments;
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

    List<SavedCommentsModel>? newComments =
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

  @override
  Widget build(BuildContext context) {
    return savedComments == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: savedComments!.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < savedComments!.length) {
                return commentWidget(savedComments![index]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
  }

  Widget commentWidget(SavedCommentsModel comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          comment.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          '${comment.username} . ${comment.communityName}',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 4),
        Text(
          comment.content,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
