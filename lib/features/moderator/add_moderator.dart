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
  List<bool> _checkBoxController = List.generate(5, (_) => true);

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close),
          ),
          title: const Text("Add a moderator"),
          actions: [
            ElevatedButton(
              onPressed: _userNameController.text.trim().isEmpty ? null : () {},
              child: const Text("Invite"),
            ),
          ],
        ),
        body: Column(
          children: [
            const Text("Username"),
            TextField(),
            const Text("Permissions"),
            Row(
              children: [
                Checkbox(
                  value: _checkBoxController[0],
                  onChanged: (value) {
                    setState(
                      () {
                        _checkBoxController[0] = value!;
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
                      value: _checkBoxController[1],
                      onChanged: (value) {
                        setState(
                          () {
                            _checkBoxController[1] = value!;
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
                      value: _checkBoxController[2],
                      onChanged: (value) {
                        setState(
                          () {
                            _checkBoxController[2] = value!;
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
                      value: _checkBoxController[3],
                      onChanged: (value) {
                        setState(
                          () {
                            _checkBoxController[3] = value!;
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
                      value: _checkBoxController[4],
                      onChanged: (value) {
                        setState(
                          () {
                            _checkBoxController[4] = value!;
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
                      value: _checkBoxController[5],
                      onChanged: (value) {
                        setState(
                          () {
                            _checkBoxController[5] = value!;
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
                      value: _checkBoxController[6],
                      onChanged: (value) {
                        setState(
                          () {
                            _checkBoxController[6] = value!;
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
                      value: _checkBoxController[7],
                      onChanged: (value) {
                        setState(
                          () {
                            _checkBoxController[7] = value!;
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
                      value: _checkBoxController[8],
                      onChanged: (value) {
                        setState(
                          () {
                            _checkBoxController[8] = value!;
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
