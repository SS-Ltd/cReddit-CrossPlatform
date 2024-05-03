import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/post/community_choice.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';
import 'package:reddit_clone/common/switch_button.dart';

//This Screen is now used to create a post
//We can use it either to create a post from Home Screen and post to comminity
//or to create a post from Profile Screen and post to profile

//todo; check link validity, test multiple images, add place to show them,
//add option to scroll them hotizontally

/// This class represents the screen for creating a new post.
/// It is a stateful widget that allows the user to enter a title, body, and other details for the post.
/// The user can also choose an image, add tags and flair, and select a community for the post.
class CreatePost extends StatefulWidget {
  /// The constructor for the [CreatePost] widget.
  /// [profile] indicates whether the post is being created from a user's profile or not.
  const CreatePost(
      {super.key, required this.profile, this.ismoderator = false});

  /// Indicates whether the post is being created from a user's profile or not.
  final bool profile;
  final bool ismoderator;
  //final String communityname

  @override
  State<CreatePost> createState() {
    return _CreatePostState();
  }
}

/// The state class for the [CreatePost] widget.
/// It manages the state of the text controllers, image picker, link insertion, poll insertion, and other UI elements.
class _CreatePostState extends State<CreatePost> {
  final _titleController = TextEditingController();
  bool _istitleempty = true;

  final _bodyController = TextEditingController();
  bool _isbodyempty = true;

  String chosenCommunity = "";
  bool hascommunity = false;

  File? _image;
  final picker = ImagePicker();
  bool _isImagePickerOpen = false;
  bool _hasImage = false;

  final _linkController = TextEditingController();
  bool _insertlink = false;
  bool _islinkempty = true;

  final List<TextEditingController> _optionControllers =
      List.generate(6, (index) => TextEditingController());
  bool _insertpoll = false;
  int count = 0;
  String _pollendsin = "2 Day";
  String endsInDateTime = '';

  bool isspoiler = false;
  bool isBrand = false;

  Subreddit? details;

  bool repeating = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime scheduledDate = DateTime.now();
  TimeOfDay scheduledTime = TimeOfDay.now();
  bool _isSaved = false;
  bool scheduleRepeating = true;
  final currentdate = DateTime.now();
  final currenttime = TimeOfDay.now();

  Future getSubredditDetails(String subredditName) async {
    final subredditDetails =
        await context.read<NetworkService>().getSubredditDetails(subredditName);
    setState(() {
      details = subredditDetails;
    });
  }

  /// Retrieves an image from the gallery or camera and sets it as the selected image for the post.
  Future getImage() async {
    if (_isImagePickerOpen) {
      return;
    }
    _isImagePickerOpen = true;

    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose image source'),
        actions: <Widget>[
          TextButton(
            child: const Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
          TextButton(
            child: const Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
        ],
      ),
    );
    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _hasImage = true;
        }
      });
    }
    _isImagePickerOpen = false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  String calculateendsin(String endsin) {
    final endsInDuration = Duration(days: int.parse(endsin));
    final newDate = DateTime.now().add(endsInDuration);
    endsInDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(newDate);
    return endsInDateTime;
  }

  Future<void> __chooseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000)!,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _chooseTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomNavigationBar(
                  isProfile: false,
                ),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: widget.ismoderator && !_istitleempty
                ? IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BottomSheet(
                                    onClosing: () {},
                                    builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 15, 20, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Post Settings"),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: ListTile(
                                            leading: const Icon(
                                                Icons.calendar_month_outlined),
                                            title: const Text("Schedule Post"),
                                            trailing: const Icon(
                                                Icons.arrow_forward_ios),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      BottomSheet(
                                                        onClosing: () {},
                                                        builder: (context) =>
                                                            Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(10,
                                                                  10, 10, 10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {},
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .arrow_back),
                                                                  ),
                                                                  const Text(
                                                                    "Schedule Post",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  !_isSaved
                                                                      ? ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              scheduledDate = _selectedDate;
                                                                              scheduledTime = _selectedTime;
                                                                              _isSaved = true;
                                                                              scheduleRepeating = repeating;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text("Save"),
                                                                        )
                                                                      : ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              scheduledDate = DateTime.now();
                                                                              _selectedDate = DateTime.now();
                                                                              scheduledTime = TimeOfDay.now();
                                                                              _selectedTime = TimeOfDay.now();
                                                                              scheduleRepeating = true;
                                                                              repeating = true;
                                                                              _isSaved = false;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text("Clear"),
                                                                        ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                        "Starts on date",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                      GestureDetector(
                                                                          onTap: () => __chooseDate(
                                                                              context),
                                                                          child:
                                                                              Text(DateFormat.yMMMd().format(_selectedDate))),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      const Text(
                                                                          "Starts at time"),
                                                                      GestureDetector(
                                                                          onTap: () => _chooseTime(
                                                                              context),
                                                                          child:
                                                                              Text(_selectedTime.format(context))),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SwitchButton(
                                                                          buttonText:
                                                                              "Repeat weekly on ${DateFormat('EEEE').format(currentdate)}",
                                                                          onPressed:
                                                                              (value) {
                                                                            setState(() {
                                                                              repeating = value;
                                                                            });
                                                                          },
                                                                          switchvalue:
                                                                              repeating),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]);
                          });
                    },
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: widget.profile || chosenCommunity.isNotEmpty
                ? ElevatedButton(
                    onPressed: _istitleempty 
                        ? null : _isbodyempty ? null 
                        : () async {
                            String type = _insertlink ? "Links" : "Post";
                            bool newpost = _insertpoll
                                ? await context
                                    //poll post
                                    .read<NetworkService>()
                                    .createNewPollPost(
                                        chosenCommunity,
                                        _titleController.text,
                                        _bodyController.text,
                                        _optionControllers
                                            .where((controller) =>
                                                controller.text.isNotEmpty)
                                            .map(
                                                (controller) => controller.text)
                                            .toList(),
                                        endsInDateTime, //month-day-year
                                        false,
                                        // .read<NetworkService>()
                                        // .user!
                                        // .isNFSW,
                                        isspoiler)
                                : (_hasImage)
                                    ? await context
                                        //image post
                                        .read<NetworkService>()
                                        .createNewImagePost(
                                            chosenCommunity,
                                            _titleController.text,
                                            _image!,
                                            false,
                                            isspoiler)
                                    : await context
                                        //text or link post
                                        .read<NetworkService>()
                                        .createNewTextOrLinkPost(
                                            type,
                                            chosenCommunity,
                                            _titleController.text,
                                            _bodyController.text,
                                            false,
                                            isspoiler);
                            ////////////////////////////////////////////////////////
                            if (newpost) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomNavigationBar(
                                    isProfile: false,
                                  ),
                                ),
                              );
                            }
                          },
                    child: const Text('Post'),
                  )
                : _isSaved
                    ? ElevatedButton(
                        onPressed: () {}, child: const Text("Schedule"))
                    : ElevatedButton(
                        onPressed: _istitleempty
                            ? null
                            : () async {
                                final returneddata = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => CommunityChoice(
                                      chosenCommunity: chosenCommunity,
                                    ),
                                  ),
                                );
                                setState(
                                  () {
                                    if (returneddata != null) {
                                      chosenCommunity = returneddata.toString();
                                      hascommunity = true;
                                      getSubredditDetails(chosenCommunity);
                                    }
                                  },
                                );
                              },
                        //in this case we will go to choose the community
                        child: const Text('Next')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              hascommunity
                  ? TextButton(
                      onPressed: () async {
                        final returneddata = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => CommunityChoice(
                              chosenCommunity: chosenCommunity,
                            ),
                          ),
                        );
                        setState(
                          () {
                            if (returneddata != null) {
                              chosenCommunity = returneddata.toString();
                              hascommunity = true;
                              getSubredditDetails(chosenCommunity);
                            }
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    details != null && details!.icon.isNotEmpty
                                        ? NetworkImage(details!.icon)
                                        : const NetworkImage(
                                            'https://picsum.photos/200/300'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(chosenCommunity),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return BottomSheet(
                                    onClosing: () {},
                                    builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.close),
                                              ),
                                              const Text(
                                                "Community Rules",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          child: Text(
                                              "Rules are different for each community. Reviewing the rules can help you be more successful when posting or commenting in this community."),
                                        ),
                                        //ListView.builder(itemBuilder: itemBuilder),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("I Understand"))
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text("Rules"),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('Add tags'),
                                          ElevatedButton(
                                            onPressed: null,
                                            child: Text('Apply'),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "Universal tags",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SwitchButton(
                                        buttonText: 'Spoiler',
                                        buttonicon: Icons.warning_amber,
                                        onPressed: (value) {
                                          setState(() {
                                            isspoiler = value;
                                          });
                                        },
                                        switchvalue: isspoiler,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SwitchButton(
                                        buttonText: 'Brand affiliate',
                                        buttonicon: Icons.warning,
                                        onPressed: (value) {
                                          setState(() {
                                            isBrand = value;
                                          });
                                        },
                                        switchvalue: isBrand,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
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
                enabled: _insertlink || _hasImage ? false : true,
                decoration: InputDecoration(
                  labelText: _isbodyempty & chosenCommunity.isEmpty ? 'body text (optional)' : chosenCommunity.isNotEmpty & _isbodyempty ? 'body text' : '',
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
                    onPressed: _hasImage || _insertpoll
                        ? null
                        : () {
                            setState(() {
                              _insertlink = !_insertlink;
                            });
                          },
                    icon: const Icon(Icons.link),
                  ),
                  IconButton(
                    onPressed: _insertlink || _insertpoll ? null : getImage,
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed:
                        _insertlink || _insertpoll || _hasImage ? null : () {},
                    icon: const Icon(Icons.video_library_outlined),
                  ),
                  IconButton(
                    onPressed: _insertlink || _hasImage
                        ? null
                        : () {
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
                                      calculateendsin('1');
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
                                      calculateendsin('2');
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
                                      calculateendsin('3');
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
                                      calculateendsin('4');
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
                                      calculateendsin('5');
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
                                      calculateendsin('6');
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
                                      calculateendsin('7');
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
