import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  const Description({super.key});

  @override
  State<Description> createState() {
    return _DescriptionState();
  }
}

class _DescriptionState extends State<Description> {
  final _descriptionController = TextEditingController();
  bool _isDescriptionEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Description"),
          actions: [
            ElevatedButton(
              onPressed: _isDescriptionEmpty ? null : () {},
              child: const Text("Save"),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Describe your community",
                ),
                onChanged: (value) {
                  setState(
                    () {
                      _isDescriptionEmpty = value.isEmpty;
                    },
                  );
                },
                maxLength: 500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
