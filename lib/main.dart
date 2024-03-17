// main.dart
import 'package:flutter/material.dart';
import 'package:reddit_clone/sidebar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // GlobalKey for ScaffoldState

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Use GlobalKey here
      appBar: AppBar(
        title: Text('Reddit Clone'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => _scaffoldKey.currentState
                ?.openEndDrawer(), // Use GlobalKey to open end drawer
          ),
        ],
      ),
      endDrawer: Sidebar(), // Use Sidebar widget from sidebar.dart
      body: Center(
        child: Text('Main Content Here'),
      ),
    );
  }
}
