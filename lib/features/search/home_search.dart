import 'package:flutter/material.dart';

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() {
    return _HomeSearchState();
  }
}

class _HomeSearchState extends State<HomeSearch> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Reddit',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
