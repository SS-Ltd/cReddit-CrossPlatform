import 'package:flutter/material.dart';

class GlobalSearch extends StatefulWidget {
  const GlobalSearch({super.key});

  @override
  State<GlobalSearch> createState() {
    return _GlobalSearchState();
  }
}

class _GlobalSearchState extends State<GlobalSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search Reddit',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.clear),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
      ),
      body: const Center(
        child: Text('Global Search'),
      ),
    );
  }
}
