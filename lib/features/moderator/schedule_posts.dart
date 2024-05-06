import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reddit_clone/features/post/create_post.dart';
import 'package:reddit_clone/models/post_model.dart';

class SchedulePosts extends StatefulWidget {
  const SchedulePosts({super.key});

  @override
  State<SchedulePosts> createState() {
    return _SchedulePostsState();
  }
}

class _SchedulePostsState extends State<SchedulePosts> {
  List<PostModel> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Scheduled posts"),
        ),
        body: posts.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "There aren't any scheduled posts in",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      "r/{} yet",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 350,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreatePost(profile: true, ismoderator: true,)));
                        },
                        child: const Text("Schedule post"),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return const ListTile(
                      //title: Text(posts[index].title),
                      //subtitle: Text(posts[index].description),
                      //trailing: Text(posts[index].scheduledTime),
                      );
                },
              ));
  }
}
