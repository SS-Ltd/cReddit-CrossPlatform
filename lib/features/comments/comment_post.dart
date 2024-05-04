// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/theme/palette.dart';

/// A page for posting comments on a post.
class CommentPostPage extends StatefulWidget {
  final String commentContent;
  final String postId;
  const CommentPostPage(
      {super.key, required this.commentContent, required this.postId});

  @override
  State<CommentPostPage> createState() {
    return _CommentPostPageState();
  }
}

class _CommentPostPageState extends State<CommentPostPage> {
  File? _image;
  final picker = ImagePicker();
  final _controller = TextEditingController();

  bool _isImagePickerOpen = false;
  bool _isTextFieldFilled = false;
  bool contentType = false; // false for text, true for image

  Future getImage() async {
    if (_isImagePickerOpen || _isTextFieldFilled) {
      return;
    }
    _isImagePickerOpen = true;

    // Show a dialog to let the user choose between the gallery and the camera
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose image source'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Gallery',
              style: TextStyle(color: Palette.blueColor),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
          TextButton(
            child: const Text(
              'Camera',
              style: TextStyle(color: Palette.blueColor),
            ),
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
          _controller.clear();
        }
      });
    }

    _isImagePickerOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add comment',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Roboto',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Post',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: postComment(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Palette.blueColor),
                              ),
                              SizedBox(width: 30),
                              Text("Posting comment..."),
                            ],
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.data != null &&
                            snapshot.data!['success'] == true) {
                          // comment was posted successfully
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(snapshot.data);
                            CustomSnackBar(
                              context: context,
                              content: 'Comment posted succesfully',
                            ).show();
                          });
                        } else if (snapshot.data != null &&
                            snapshot.data!['success'] == false) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            CustomSnackBar(
                              context: context,
                              content: 'Failed to post comment',
                            ).show();
                          });
                        }
                        return const SizedBox.shrink();
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.commentContent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, thickness: 0.15),
                    Semantics(
                      identifier: 'Your Comment',
                      label: 'Your Comment',
                      child: TextFormField(
                        controller: _controller,
                        autofocus: true,
                        maxLines: null,
                        onChanged: (text) {
                          setState(() {
                            _isTextFieldFilled = text.isNotEmpty;
                          });
                        },
                        enabled: _image == null,
                        decoration: InputDecoration(
                          hintText: _image == null ? 'Your comment' : null,
                          hintStyle: const TextStyle(fontSize: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_image != null) Image.file(_image!),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.grey, thickness: 0.15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String text = '';
                          String link = '';
                          return AlertDialog(
                            backgroundColor: Palette.settingsHeading,
                            title: const Text('Insert a link'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    onChanged: (value) {
                                      text = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Name",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      link = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Link",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Palette.transparent,
                                          foregroundColor: Palette.greyColor,
                                          shadowColor: Palette.transparent,
                                          minimumSize:
                                              const Size(double.infinity, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                        ),
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Palette.blueJoinColor,
                                          foregroundColor: Palette.whiteColor,
                                          shadowColor: Palette.transparent,
                                          minimumSize:
                                              const Size(double.infinity, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                        ),
                                        child: const Text('Insert'),
                                        onPressed: () {
                                          if (text.isEmpty || link.isEmpty) {
                                            Navigator.of(context).pop();
                                            CustomSnackBar(
                                              context: context,
                                              content:
                                                  'Please fill in both fields',
                                            ).show();
                                          } else {
                                            String markdownLink =
                                                '[$text](http://$link)';
                                            Navigator.of(context)
                                                .pop(markdownLink);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ).then((markdownLink) {
                        if (markdownLink != null) {
                          _controller.text += markdownLink;
                          setState(() {
                            _isTextFieldFilled = true;
                          });
                        }
                      });
                    }),
                if (_image != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.insert_photo_outlined),
                  onPressed: _isTextFieldFilled ? null : getImage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> postComment() async {
    if (_controller.text.isNotEmpty) {
      Map<String, dynamic> result = await context
          .read<NetworkService>()
          .createNewTextComment(widget.postId, _controller.text);
      if (result['success'] == false) {
        return {'success': false};
      }
      contentType = false; // Text is entered
      return {
        'success': true,
        'content': _controller.text,
        'contentType': contentType,
        'commentId': result['commentId'],
        'user': result['user']
      };
    } else if (_image != null) {
      Map<String, dynamic> result = await context
          .read<NetworkService>()
          .createNewImageComment(widget.postId, _image!);
      if (result['success'] == false) {
        return {'success': false};
      }
      contentType = true; // Image is entered
      return {
        'success': true,
        'content': _image,
        'contentType': contentType,
        'commentId': result['commentId'],
        'user': result['user']
      };
    } else {
      return {'success': false};
    }
  }
}
