import 'package:flutter/material.dart';
import 'package:reddit_clone/features/search/global_search.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

//this page will be used to search inside home and communities page

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() {
    return _HomeSearchState();
  }
}

class _HomeSearchState extends State<HomeSearch> {
  final _searchController = TextEditingController();
  List<SearchComments> searchResults = [];
  String searchQuery = '';
  
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
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Reddit',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              contentPadding: const EdgeInsets.all(10),
            ),
            onChanged: (value) async {
              setState(() {
                searchQuery = value;
              });
              searchResults =
                  await Provider.of<NetworkService>(context, listen: false)
                      .getSearchComment(value);
              print(searchResults);
            },
            onTap: () {},
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    //leading: ,
                    title: Text(searchResults[index].postTitle),
                    onTap: () {
                      // Navigate to the post and add to recenltt search
                    },
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.clear),
                    ),
                  );
                },
              ),
            ),
            if (searchQuery.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const GlobalSearch(),
                    ),
                  );
                },
                child: Text('Search for $searchQuery'),
              )
          ],
        ),
      ),
    );
  }
}
