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
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(6, (index) => TextEditingController());

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
  String _pollendsin = "2 Day";

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
                        :  () async {
                            String type = _insertlink ? "Links" : "Post";
                            bool newpost = await context
                                .read<NetworkService>()
                                .createNewTextOrLinkPost(
                                    type,
                                    chosenCommunity,
                                    _titleController.text,
                                    _bodyController.text,
                                    false,
                                    false);
                            ////////////////////////////////////////////////////////
                            if (newpost) {
                              Navigator.of(context).pop();
                            } else {}
                          },
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
              widget.profile || chosenCommunity.isNotEmpty
                  ? Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              const Size(150, 8),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return BottomSheet(
                                      onClosing: () {},
                                      builder: (context) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text('Add tags'),
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    child: const Text('Apply'),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ));
                                });
                          },
                          child: const Text('Add tags & flair'),
                        ),
                      ],
                    )
                  : const SizedBox(),
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
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
//-----------------------------------------------------------------------------------------------------------//
                        return BottomSheet(
                          onClosing: () {},
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                title: const Text('1 Day'),
                                value: '1 Day',
                                groupValue: _pollendsin,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _pollendsin = value!;
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile(
                                title: const Text('2 Day'),
                                value: '2 Day',
                                groupValue: _pollendsin,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _pollendsin = value!;
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile(
                                title: const Text('3 Day'),
                                value: '3 Day',
                                groupValue: _pollendsin,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _pollendsin = value!;
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile(
                                title: const Text('4 Day'),
                                value: '4 Day',
                                groupValue: _pollendsin,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _pollendsin = value!;
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile(
                                title: const Text('5 Day'),
                                value: '5 Day',
                                groupValue: _pollendsin,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _pollendsin = value!;
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile(
                                title: const Text('6 Day'),
                                value: '6 Day',
                                groupValue: _pollendsin,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _pollendsin = value!;
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile(
                                title: const Text('7 Day'),
                                value: '7 Day',
                                groupValue: _pollendsin,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _pollendsin = value!;
                                    },
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  label: Text('Poll ends in $_pollendsin'),
                  icon: const Icon(Icons.arrow_drop_down),
                ),
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
              controller: _optionControllers[0],
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Option 2',
                border: InputBorder.none,
              ),
              controller: _optionControllers[1],
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
                            border: InputBorder.none),
                        controller: _optionControllers[index + 2],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            count = count - 1;
                            _optionControllers[index + 2].clear();
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
