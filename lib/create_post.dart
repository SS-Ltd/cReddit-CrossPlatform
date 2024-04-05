import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/Network.dart';
import 'package:reddit_clone/community_choice.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

//This Screen is now used to create a post
//We can use it either to create a post from Home Screen and post to comminity
//or to create a post from Profile Screen and post to profile

//todo; check link validity, test multiple images, add place to show them,
//add option to scroll them hotizontally

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
  String chosenCommunity = "";

  File? _image;
  final ImagePicker picker = ImagePicker();
  bool _isImagePickerOpen = false;

  final _linkController = TextEditingController();
  bool _insertlink = false;
  bool _islinkempty = true;

  bool _insertpoll = false;
  int count = 0;

  Future getImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
    _isImagePickerOpen = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            child: widget.profile || chosenCommunity.isNotEmpty
                ? ElevatedButton(
                    onPressed: _istitleempty
                        ? null
                        : () async {
                            //i shpuld add requests for different types of posts
                            bool newpost = await context
                                .read<NetworkService>()
                                .createNewPost('Post', "",
                                    "Testing", "", false, false);
                          ////////////////////////////////////////////////////////
                            if (newpost) {
                              Navigator.pop(context);
                            } else {
                              const snackBar = SnackBar(
                                content: Text('Failed to create post'),
                              );
                          
                            }
                          },
                    //in this case we will add the post to the profile
                    child: const Text('Post'),
                  )
                : ElevatedButton(
                    onPressed: _istitleempty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => CommunityChoice(
                                  chosenCommunity: chosenCommunity,
                                ),
                              ),
                            );
                          },
                    //in this case we will go to choose the community
                    //then add the post to the subreddit
                    child: const Text('Next')),
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
                onChanged: (value) {
                  setState(() {
                    _istitleempty = value.isEmpty;
                  });
                },
              ),
              _insertlink
                  ? TextField(
                      decoration: InputDecoration(
                        labelText: _islinkempty ? 'Enter link' : '',
                        labelStyle: const TextStyle(fontSize: 30),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _linkController.clear();
                              _insertlink = false;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      controller: _linkController,
                      onChanged: (value) {
                        setState(() {
                          _islinkempty = value.isEmpty;
                        });
                      },
                    )
                  : const SizedBox(),
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
                    onPressed: () {
                      setState(() {
                        _insertlink = !_insertlink;
                      });
                    },
                    icon: const Icon(Icons.link),
                  ),
                  IconButton(
                    onPressed: getImage,
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.video_library_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _insertpoll = !_insertpoll;
                      });
                    },
                    icon: const Icon(Icons.poll_outlined),
                  ),
                ],
              ),
              _insertpoll ? openpollcreator() : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget openpollcreator() {
    final _option1 = TextEditingController();
    final _option2 = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Poll ends in'),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _insertpoll = !_insertpoll;
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Option 1',
                border: InputBorder.none,
              ),
              controller: _option1,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Option 2',
                border: InputBorder.none,
              ),
              controller: _option2,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 3}',
                        ),
                        onChanged: (value) {
                          // Handle the input value for each option
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            count = count - 1;
                          });
                        },
                        icon: const Icon(Icons.close))
                  ],
                );
              },
            ),
            (count < 4)
                ? Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            count = count + 1;
                          });
                        },
                        label: const Text('Add option'),
                        icon: const Icon(Icons.add),
                      )
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
