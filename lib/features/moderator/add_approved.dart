import 'package:flutter/material.dart';

class AddModerator extends StatefulWidget {
  const AddModerator({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddModeratorSatet();
  }
}

class _AddModeratorSatet extends State<AddModerator> {
  final _userNameController = TextEditingController();
  bool _isusernameempty = true;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          title: const Text("Add an approved user"),
          actions: [
            ElevatedButton(
              onPressed: _isusernameempty ? null : () {},
              child: const Text("Add"),
            ),
          ],
        ),
        body: Column(
          children: [
            const Text("Username"),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                prefixText: "u/",
                hintText: "username",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding: const EdgeInsets.all(10),
              ),
              onChanged: (value) {
                setState(
                  () {
                    _isusernameempty = value.isEmpty;
                  },
                );
              },
            ),
            const SizedBox(
              width: 300,
              child: Text(
                "This user will be able to submit cpntent to your community",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
