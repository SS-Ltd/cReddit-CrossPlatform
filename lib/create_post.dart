import 'package:flutter/material.dart';
import 'package:reddit_clone/community_choice.dart';

//This Screen is now used to create a post
//We can use it either to create a post from Home Screen and post to comminity
//or to create a post from Profile Screen and post to profile

class CreatePost extends StatefulWidget {
  const CreatePost({super.key, required this.profile});

  final bool profile;

  @override
  State<CreatePost> createState() {
    return _CreatePostState();
  }
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _istitleempty = true;
  bool _isbodyempty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: widget.profile
                ? ElevatedButton(
                    onPressed: () {},
                    //in this case we will add the post to the profile
                    child: const Text('Post'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const CommunityChoice(),
                        ),
                      );
                    },
                    //in this case we will go to choose the community
                    //then add the post to the subreddit
                    child: const Text('Next'),
                  ),
          ),
        ],
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: _istitleempty ? 'Title' : '',
                  labelStyle: const TextStyle(fontSize: 30),
                  border: InputBorder.none,
                ),
                controller: _titleController,
                onChanged: (text) {
                  setState(() {
                    _istitleempty = text.isEmpty;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: _isbodyempty ? 'body text (optional)' : '',
                  border: InputBorder.none,
                ),
                controller: _bodyController,
                onChanged: (text) {
                  setState(
                    () {
                      _isbodyempty = text.isEmpty;
                    },
                  );
                },
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.link),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.video_library_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.poll_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
