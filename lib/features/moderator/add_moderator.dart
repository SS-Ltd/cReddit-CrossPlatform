import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

class AddModerator extends StatefulWidget {
  const AddModerator({super.key, required this.communityName});

  final String communityName;

  @override
  State<AddModerator> createState() {
    return _AddModeratorState();
  }
}

class _AddModeratorState extends State<AddModerator> {
  final _userNameController = TextEditingController();
  bool _isusernameempty = true;
  List<bool> checkBoxController = List.generate(9, (_) => true);

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          title: const Text("Add a moderator"),
          actions: [
            ElevatedButton(
              key: const Key('InviteButton'),
              onPressed: _isusernameempty
                  ? null
                  : () async {
                      bool newModerator = await Provider.of<NetworkService>(
                              context,
                              listen: false)
                          .addModerator(
                              _userNameController.text, widget.communityName);
                      if (newModerator) {
                        CustomSnackBar(
                                context: context,
                                content:
                                    "u/${_userNameController.text} was invited",
                                backgroundColor: Colors.white,
                                textColor: Colors.black)
                            .show();
                        Navigator.pop(context);
                      }
                    },
              child: const Text("Invite"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextField(
                key: const Key('username'),
                controller: _userNameController,
                decoration: InputDecoration(
                  prefixText: "u/",
                  hintText: "username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                ),
                onChanged: (value) {
                  setState(() {
                    _isusernameempty = value.isEmpty;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Permissions"),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  key: const Key('checkbox_0'),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      key: const Key('checkbox_1'),
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
                const SizedBox(
                  width: 150,
                ),
                Row(
                  children: [
                    Checkbox(
                      key: const Key('checkbox_2'),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      key: const Key('checkbox_3'),
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
                const SizedBox(
                  width: 155,
                ),
                Row(
                  children: [
                    Checkbox(
                      key: const Key('checkbox_4'),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      key: const Key('checkbox_5'),
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
                const SizedBox(
                  width: 170,
                ),
                Row(
                  children: [
                    Checkbox(
                      key: const Key('checkbox_6'),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      key: const Key('checkbox_7'),
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
                const SizedBox(
                  width: 125,
                ),
                Row(
                  children: [
                    Checkbox(
                      key: const Key('checkbox_8'),
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
