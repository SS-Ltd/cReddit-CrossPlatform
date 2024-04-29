import 'package:flutter/material.dart';

class AddModerator extends StatefulWidget {
  const AddModerator({super.key});

  @override
  State<AddModerator> createState() {
    return _AddModeratorSatet();
  }
}

class _AddModeratorSatet extends State<AddModerator> {
  final _userNameController = TextEditingController();
  bool _isusernameempty = true;
  List<bool> checkBoxController = List.generate(9, (_) => true);

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
          title: const Text("Add a moderator"),
          actions: [
            ElevatedButton(
              onPressed: _isusernameempty ? null : () {},
              child: const Text("Invite"),
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
                setState(() {
                  _isusernameempty = value.isEmpty;
                });
              },
            ),
            const Text("Permissions"),
            Row(
              children: [
                Checkbox(
                  value: checkBoxController[0],
                  onChanged: (value) {
                    setState(
                      () {
                        checkBoxController[0] = value!;
                      },
                    );
                  },
                ),
                const Text("Full permissions")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxController[1],
                      onChanged: (value) {
                        setState(
                          () {
                            checkBoxController[1] = value!;
                          },
                        );
                      },
                    ),
                    const Text("Access")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxController[2],
                      onChanged: (value) {
                        setState(
                          () {
                            checkBoxController[2] = value!;
                          },
                        );
                      },
                    ),
                    const Text("Mail")
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxController[3],
                      onChanged: (value) {
                        setState(
                          () {
                            checkBoxController[3] = value!;
                          },
                        );
                      },
                    ),
                    const Text("Config")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxController[4],
                      onChanged: (value) {
                        setState(
                          () {
                            checkBoxController[4] = value!;
                          },
                        );
                      },
                    ),
                    const Text("Posts")
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxController[5],
                      onChanged: (value) {
                        setState(
                          () {
                            checkBoxController[5] = value!;
                          },
                        );
                      },
                    ),
                    const Text("Flair")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxController[6],
                      onChanged: (value) {
                        setState(
                          () {
                            checkBoxController[6] = value!;
                          },
                        );
                      },
                    ),
                    const Text("Wiki")
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxController[7],
                      onChanged: (value) {
                        setState(
                          () {
                            checkBoxController[7] = value!;
                          },
                        );
                      },
                    ),
                    const Text("Chat config"),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: checkBoxController[8],
                      onChanged: (value) {
                        setState(
                          () {
                            checkBoxController[8] = value!;
                          },
                        );
                      },
                    ),
                    const Text("Chat operator"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
