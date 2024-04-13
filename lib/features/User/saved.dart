import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/comments/saved_comments.dart';
import 'package:reddit_clone/features/post/saved_posts.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});
  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Posts'),
            Tab(text: 'Comments'),
          ],
          labelStyle: const TextStyle(fontSize: 18),
          unselectedLabelStyle: const TextStyle(fontSize: 18),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SavedPosts(),
          SavedComments(),
        ],
      ),
    );
  }
}
