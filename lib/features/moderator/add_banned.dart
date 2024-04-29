import 'package:flutter/material.dart';

class Addbanned extends StatefulWidget {
  const Addbanned({super.key});

  @override
  State<Addbanned> createState() {
    return _AddBannedState();
  }
}

class _AddBannedState extends State<Addbanned> {
  final _userNameController = TextEditingController();
  final _reasonController = TextEditingController();
  final _modnoteController = TextEditingController();
  final _howlongController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isusernameempty = true;
  bool _isreasonempty = true;
  bool _ismodnoteempty = true;
  bool _ispermanent = true;
  bool _ishowlongempty = true;
  bool _isnoteempty = true;

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
          title: const Text("Add a banned user"),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: const Text("Add"),
            ),
          ],
        ),
        body: Column(
          children: [
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
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  prefixText: "u/",
                  hintText: "username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
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
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Reason for ban"),
                ],
              ),
            ),
            //update this////////////
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  prefixText: "u/",
                  hintText: "username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  contentPadding: const EdgeInsets.all(10),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      //_isusernameempty = value.isEmpty;
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Mod note"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextField(
                controller: _modnoteController,
                decoration: InputDecoration(
                  hintText: "Only mods will see this",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  contentPadding: const EdgeInsets.all(10),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      _ismodnoteempty = value.isEmpty;
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("How long"),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _howlongController,
                    decoration: InputDecoration(
                      hintText: "1 day",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    onChanged: (value) {
                      setState(
                        () {
                          _ishowlongempty = value.isEmpty;
                        },
                      );
                    },
                  ),
                ),
                const Text('Days'),
                const SizedBox(
                  width: 10,
                ),
                Checkbox(
                  value: _ispermanent,
                  onChanged: (value) {
                    setState(
                      () {
                        _ispermanent = value!;
                      },
                    );
                  },
                ),
                const Text("Permanent"),
              ],
            ),
            const Text("Note to include in ban message"),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: "The user will receive this note in a message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  contentPadding: const EdgeInsets.all(10),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      _isnoteempty = value.isEmpty;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
