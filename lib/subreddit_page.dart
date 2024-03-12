import 'package:flutter/material.dart';

class SubRedditPage extends StatefulWidget {
  const SubRedditPage({super.key});

  @override
  State<SubRedditPage> createState() => _SubRedditPageState();
}

class _SubRedditPageState extends State<SubRedditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          title: Text('r/SubredditName', style: TextStyle(color: Colors.white)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/200/300'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            _iconButtonWithBackground(Icons.search, () {}),
            _iconButtonWithBackground(Icons.share_outlined, () {}),
            _iconButtonWithBackground(Icons.more_vert, () {}),
          ],
        ),
      ),
    );
  }

  Widget _iconButtonWithBackground(IconData icon, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.black45, // Semi-transparent black
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
