import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reddit_clone/utils/utils_time.dart';

/// A page for replying to a comment.
class ReplyPage extends StatefulWidget {
  final String commentContent;
  final String username;
  final DateTime timestamp;

  /// Constructs a [ReplyPage] with the given [commentContent], [username], and [timestamp].
  ReplyPage({
    super.key,
    required this.commentContent,
    required this.username,
    required this.timestamp,
  });

  @override
  State<StatefulWidget> createState() {
    return _ReplyPageState();
  }
}

class _ReplyPageState extends State<ReplyPage> {
  File? _image;
  final picker = ImagePicker();
  final _controller = TextEditingController();

  bool _isImagePickerOpen = false;
  bool _isTextFieldFilled = false;
  bool contentType = false; // false for text, true for image

  /// Retrieves an image from the device's gallery.
  Future getImage() async {
    if (_isImagePickerOpen || _isTextFieldFilled) {
      return;
    }
    _isImagePickerOpen = true;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _controller.clear();
      }
    });

    _isImagePickerOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reply',
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
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                contentType = false; // Text is entered
                Navigator.pop(context,
                    {'content': _controller.text, 'contentType': contentType});
              } else if (_image != null) {
                contentType = true; // Image is uploaded
                Navigator.pop(
                    context, {'content': _image, 'contentType': contentType});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please enter a message'),
                    duration: const Duration(seconds: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
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
                    Row(
                      children: <Widget>[
                        Text(
                          widget.username,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatTimestamp(widget.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.commentContent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey, thickness: 0.15),
                    TextFormField(
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
                        hintText: _image == null ? 'Your reply' : null,
                        hintStyle: const TextStyle(fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                    if (_image != null) Image.file(_image!),
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
}
