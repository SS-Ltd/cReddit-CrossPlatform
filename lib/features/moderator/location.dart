import 'package:flutter/material.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() {
    return _LocationState();
  }
}

class _LocationState extends State<Location> {
  final _locationController = TextEditingController();
  bool _islocationempty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Location'),
        actions: [
          ElevatedButton(
            onPressed: _islocationempty ? null : () {},
            child: const Text("save"),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            width: 400,
            child: Text(
              "Adding a location helps your community show up in search results and recommendations and helps local redditors find it easier.",
              softWrap: true,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Region"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                hintText: "City, state or zip code",
                contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              ),
              onChanged: (value) => setState(() {
                _islocationempty = value.isEmpty;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
