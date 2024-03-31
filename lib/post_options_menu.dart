import 'package:flutter/material.dart';

enum Menu {
  share,
  subscribe,
  save,
  copytext,
  edit,
  addpostflair,
  markspoiler,
  markNSFW,
  markasbrandaffiliate,
  report,
  block,
  hide,
  delete
}

class PostOptionsMenu extends StatelessWidget {
  const PostOptionsMenu({super.key, required this.profile});

  final bool profile;

  @override
  Widget build(BuildContext context) {
    return 
      PopupMenuButton<Menu>(
        onSelected: (Menu item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          //////////////////////////////////////////
          const PopupMenuItem<Menu>(
              value: Menu.share,
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
              )),
          const PopupMenuItem<Menu>(
              value: Menu.subscribe,
              child: ListTile(
                leading: Icon(Icons.add_alert),
                title: Text('Subscribe'),
              )),
          const PopupMenuItem<Menu>(
              value: Menu.save,
              child: ListTile(
                leading: Icon(Icons.bookmark_add_outlined),
                title: Text('Share'),
              )),
          const PopupMenuItem<Menu>(
              value: Menu.copytext,
              child: ListTile(
                leading: Icon(Icons.copy),
                title: Text('Copy text'),
              )),
          const PopupMenuItem<Menu>(
              value: Menu.edit,
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
              )),
          const PopupMenuItem<Menu>(
              value: Menu.addpostflair,
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('Add post flair'),
              )),
      
          const PopupMenuItem<Menu>(
              value: Menu.markspoiler,
              child: ListTile(
                leading: Icon(Icons.warning),
                title: Text('Mark spoiler'),
              )),
          const PopupMenuItem<Menu>(
              value: Menu.markNSFW,
              child: ListTile(
                leading: Icon(Icons.warning),
                title: Text('Mark NSFW'),
              )),
          const PopupMenuItem<Menu>(
              value: Menu.markasbrandaffiliate,
              child: ListTile(
                leading: Icon(Icons.warning),
                title: Text('Mark as brand affiliate'),
              )),
          const PopupMenuItem<Menu>(
              value: Menu.report,
              child: ListTile(
                leading: Icon(Icons.warning),
                title: Text('Report'),
              )),
        ],
    );
  }
}
