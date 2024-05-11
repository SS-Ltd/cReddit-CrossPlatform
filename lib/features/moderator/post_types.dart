import 'package:flutter/material.dart';
import 'package:reddit_clone/common/selection_button.dart';
import 'package:reddit_clone/common/switch_button.dart';

class PostTypes extends StatefulWidget {
  const PostTypes({super.key});

  @override
  State<PostTypes> createState() {
    return _PostTypesState();
  }
}

class _PostTypesState extends State<PostTypes> {
  bool _imagePosts = true;
  bool _videoPosts = true;
  bool _pollPosts = true;
  String _postType = "Any";

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Post types"),
          actions: [
            ElevatedButton(
              onPressed: (_postType == "Any" &&
                      _imagePosts == true &&
                      _videoPosts == true &&
                      _pollPosts == true)
                  ? null
                  : () {},
              child: const Text("Save"),
            ),
          ],
        ),
        body: Column(
          children: [
            SelectionButton(
              key: const Key('openmodel'),
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
                            RadioListTile(
                              title: const Text("Any"),
                              subtitle: const Text(
                                  "Allow text, link, image, and video posts"),
                              value: 'Any',
                              groupValue: _postType,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _postType = value.toString();
                                  },
                                );
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RadioListTile(
                              title: const Text("Link only"),
                              subtitle: const Text("Only allow link posts"),
                              value: 'Link',
                              groupValue: _postType,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _postType = value.toString();
                                  },
                                );
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RadioListTile(
                              title: const Text("Text only"),
                              subtitle: const Text("Only allow text posts"),
                              value: 'Text',
                              groupValue: _postType,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _postType = value.toString();
                                  },
                                );
                                Navigator.pop(context);
                              },
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
                buttonText: "Post type options",
                selectedtext: _postType,
                optional:
                    "Choose the types of posts you allow in your community"),
            if (_postType != 'Text')
              SwitchButton(
                buttonText: "Image posts",
                onPressed: (value) {
                  setState(
                    () {
                      _imagePosts = value;
                    },
                  );
                },
                switchvalue: _imagePosts,
                optional:
                    "Allow images uploaded directly to Reddit as well as links to popular image hosting sites such as lmgur",
              ),
            if (_postType != 'Text')
              SwitchButton(
                buttonText: "Video posts",
                onPressed: (value) {
                  setState(
                    () {
                      _videoPosts = value;
                    },
                  );
                },
                switchvalue: _videoPosts,
                optional: "Allow videos uploaded directly to Reddit",
              ),
            const SizedBox(
              height: 20,
            ),
            SwitchButton(
              buttonText: "Poll posts",
              onPressed: (value) {
                setState(
                  () {
                    _pollPosts = value;
                  },
                );
              },
              switchvalue: _pollPosts,
              optional: "Allow poll posts in your community",
            ),
          ],
        ),
      ),
    );
  }
}
