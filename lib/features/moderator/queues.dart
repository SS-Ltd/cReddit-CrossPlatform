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

  String _selectedMod = "Queues";
  String _selectedQueue = "Needs Review";
  String _selectedCommunity = "Community";
  String _selectedFilter = "Posts and Comments";

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
          child: Text(_selectedMod),
        ),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: <Widget>[
            ElevatedButton(onPressed: () {}, child: Text(_selectedCommunity)),
            ElevatedButton(
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
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Queues",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.close)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedQueue = "Needs Review";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const ListTile(
                                    title: Text("Needs Review"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedQueue = "Removed";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const ListTile(
                                    title: Text("Removed"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedQueue = "Reported";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const ListTile(
                                    title: Text("Reported"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedQueue = "Edited";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const ListTile(
                                    title: Text("Edited"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedQueue = "Unmoderated";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const ListTile(
                                    title: Text("Unmoderated"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(_selectedQueue)),
            ElevatedButton(
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
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Filter by content",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.close)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFilter = "Posts and Comments";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const ListTile(
                                    title: Text("Posts and Comments"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFilter = "Posts Only";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const ListTile(
                                    title: Text("Posts Only"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFilter = "Cpmments Only";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const ListTile(
                                    title: Text("Comments Only"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(_selectedFilter)),
            ElevatedButton(onPressed: () {}, child: const Text("sort")),
          ],
          labelStyle: const TextStyle(fontSize: 16),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: Palette.blueColor),
            insets: EdgeInsets.symmetric(horizontal: 0),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Good job",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Everything's been reviewed",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Go to community page")),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Good job",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Everything's been reviewed",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Go to community page")),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Good job",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Everything's been reviewed",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Go to community page")),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Good job",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Everything's been reviewed",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {}, child: const Text("Go to community page")),
            ],
          ),
        ],
      ),
    );
  }
}
