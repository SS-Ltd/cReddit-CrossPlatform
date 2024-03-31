import 'package:flutter/material.dart';
import 'package:reddit_clone/features/post/post.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic shownvalue = 'Home';
  List<String> list = ['Home', 'Popular'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //another method is to make it as a leading with icon button and this icon button opens the drawer
      drawer: Drawer(),
        appBar: AppBar(
          title: TextButton(
              onPressed: () {},
              child: Row(
                children: [Text('asdasd'), Icon(Icons.keyboard_arrow_down)],
              )),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, size: 30.0),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.reddit, size: 30.0),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 5, // replace with the number of Post widgets you have
          itemBuilder: (context, index) {
            return MockPost();
          },
        ));
  }

  Container MockPost() {
    return Container(
      height: 550,
      child: Post(
          communityName: 'Entrepreneur',
          userName: 'throwaway123',
          title: 'Escaping corporate Hell and finding freedom',
          imageUrl:
              'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
          content:
              'Man, let me have a  vent for a minute. Just got out of the shittiest gig ever – being a "marketing specialist" for the supposed big boys over at Microsoft. Let me tell you, it was not bad.',
          timeStamp: DateTime.now()),
    );
  }
}

// DropdownButton(
//             value: shownvalue,
//             icon: const Icon(Icons.arrow_downward),
//             onChanged: (value) {
//               setState(() {
//                 shownvalue = value;
//               });
//             },
//             items: list.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(value: value, child: Text(value));
//             }).toList(),
//           ),