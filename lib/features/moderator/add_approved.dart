import 'package:flutter/material.dart';

class AddApproved extends StatefulWidget {
  const AddApproved({super.key});

  @override
  State<AddApproved> createState() {
    return _AddApprovedState();
  }
}

class _AddApprovedState extends State<AddApproved> {
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
            const Divider(
              thickness: 1,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Username"),
                ],
              ),
            ),
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
            const Row(
              children: [
                Text(
                  "This user will be able to submit cpntent to your community",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
