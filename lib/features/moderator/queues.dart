import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/theme.dart';

class Queues extends StatefulWidget {
  const Queues({super.key});

  @override
  State<Queues> createState() {
    return _QueuesState();
  }
}

class _QueuesState extends State<Queues> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _selectedQueue = "Queues";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: ElevatedButton(
          onPressed: () {},
          child: Text(_selectedQueue),
        ),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: <Widget>[
            SizedBox(
                width: 150,
                child:
                    ElevatedButton(onPressed: () {}, child: Text("community"))),
            ElevatedButton(onPressed: () {}, child: Text("queue")),
            ElevatedButton(onPressed: () {}, child: Text("filter")),
            ElevatedButton(onPressed: () {}, child: Text("sort")),
          ],
          labelStyle: const TextStyle(fontSize: 16),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: Palette.blueColor),
            insets: EdgeInsets.symmetric(horizontal: -25),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Text('All Queues'),
          Text('Editable Queues'),
          Text('Uneditable Queues'),
          Text('Custom Queues'),
        ],
      ),
    );
  }
}
