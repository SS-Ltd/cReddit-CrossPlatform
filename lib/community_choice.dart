import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommunityChoice extends StatefulWidget {
  const CommunityChoice({
    super.key,
  });

  @override
  State<CommunityChoice> createState() {
    return _CommunityChoiceState();
  }
}

class _CommunityChoiceState extends State<CommunityChoice> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Post to'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        //controller: _communityNameController,
                        decoration: InputDecoration(
                          hintText: 'Search for a community',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
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
