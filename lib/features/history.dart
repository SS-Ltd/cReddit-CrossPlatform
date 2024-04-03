import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String currentSort = 'Recent';
  IconData currentIcon = Icons.access_time;

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Sort History By",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            _sortingOptionTile('Recent', Icons.access_time, () {
              _updateSorting('Recent', Icons.access_time);
            }),
            _sortingOptionTile('Upvoted', Icons.thumb_up, () {
              _updateSorting('Upvoted', Icons.thumb_up);
            }),
            _sortingOptionTile('Downvoted', Icons.thumb_down, () {
              _updateSorting('Downvoted', Icons.thumb_down);
            }),
          ],
        );
      },
    );
  }

  void _updateSorting(String sortOption, IconData icon) {
    setState(() {
      currentSort = sortOption;
      currentIcon = icon;
    });
    Navigator.pop(context); // Close the modal bottom sheet
  }

  Widget _sortingOptionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(currentIcon, color: Colors.grey),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentSort, style: const TextStyle(color: Colors.grey)),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
            onTap: _showSortOptions,
          ),
          Expanded(
            child: Center(
              child: Text('Content sorted by $currentSort',
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
