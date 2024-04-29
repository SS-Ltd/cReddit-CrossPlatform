// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/theme/palette.dart';

/// A page for editing a comment.
///
/// This page allows the user to edit a comment. It provides a text field for
/// editing the comment content and options for adding or removing an image
/// associated with the comment. The edited comment can be saved and returned
/// to the previous page.
class EditCommentPage extends StatefulWidget {
  final String commentId;
  final String commentContent;
  final bool contentType; // false for text, true for image
  final File? photo; // URL or path to the photo
  int imageSource; // Source of the image

  EditCommentPage({
    Key? key,
    required this.commentId,
    required this.commentContent,
    required this.contentType,
    required this.photo,
    required this.imageSource,
  }) : super(key: key);

  @override
  State<EditCommentPage> createState() {
    return _EditCommentPageState();
  }
}

class _EditCommentPageState extends State<EditCommentPage> {
  File? _image;
  String? _imageUrl;
  final picker = ImagePicker();
  final _controller = TextEditingController();

  bool _isImagePickerOpen = false;
  bool _isTextFieldFilled = false;

  Future getImage() async {
    if (_isImagePickerOpen || _isTextFieldFilled || !widget.contentType) {
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
          _imageUrl = null;
          widget.imageSource = 1;
          _controller.clear();
        }
      });
    }

    _isImagePickerOpen = false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.contentType == false)
      _controller.text = widget.commentContent;
    else if (widget.contentType == true && widget.imageSource == 0) {
      _imageUrl = widget.commentContent;
    } else if (widget.contentType == true && widget.imageSource == 1) {
      _image = widget.photo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit comment',
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
            child: const Text('Save',
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
                    future: saveComment(),
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
                              Text("Saving comment..."),
                            ],
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.data != null &&
                            snapshot.data!['edited'] == true) {
                          // comment was saved successfully
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(snapshot.data);
                            CustomSnackBar(
                              context: context,
                              content: 'Comment editted successfully',
                            ).show();
                          });
                        } else if (snapshot.data != null &&
                            snapshot.data!['edited'] == false) {
                          // comment saving failed
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            CustomSnackBar(
                              context: context,
                              content: 'Failed to edit comment',
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
                    TextFormField(
                      controller: _controller,
                      autofocus: true,
                      maxLines: null,
                      onChanged: (text) {
                        setState(() {
                          _isTextFieldFilled = text.isNotEmpty;
                        });
                      },
                      enabled: _image == null && widget.contentType == false,
                      decoration: InputDecoration(
                        hintText: _image == null ? 'Your comment' : null,
                        hintStyle: const TextStyle(fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                    if (_image != null) Image.file(_image!),
                    if (_imageUrl != null) Image.network(_imageUrl!),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.grey, thickness: 0.15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (_image != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                  ),
                if (_imageUrl != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _imageUrl = null;
                        //widget.imageSource = 1;
                      });
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.insert_photo_outlined),
                  onPressed: _isTextFieldFilled || widget.contentType == false
                      ? null
                      : getImage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> saveComment() async {
    if (_controller.text.isNotEmpty) {
      bool edited = await context
          .read<NetworkService>()
          .editTextComment(widget.commentId, _controller.text);
      return {
        'edited': edited,
        'content': _controller.text,
        'contentType': widget.contentType,
        'imageSource': widget.imageSource,
      };
    }
    if (_image != null) {
      bool edited = await context
          .read<NetworkService>()
          .editImageComment(widget.commentId, _image!);
      return {
        'edited': edited,
        'content': _image,
        'contentType': widget.contentType,
        'imageSource': widget.imageSource,
      };
    }
    return {'edited': false};
  }
}
