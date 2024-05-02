import 'package:flutter/material.dart';

class AddRule extends StatefulWidget {
  const AddRule({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  State<AddRule> createState() {
    return _AddRuleState();
  }
}

class _AddRuleState extends State<AddRule> {
  bool _istitleempty = true;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _reportController = TextEditingController();
  String _reportReason = "P&C";

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
          title: widget.isEditing ? const Text("Edit rule") : const Text("Create rule"),
          actions: [
            ElevatedButton(
              onPressed: _istitleempty ? null : () {},
              child: const Text("Save"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      "Title",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Rule title",
                  contentPadding: EdgeInsets.all(10),
                ),
                maxLength: 100,
                maxLines: 3,
                onChanged: (value) {
                  setState(
                    () {
                      _istitleempty = value.isEmpty;
                    },
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text("Description"),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Rule description",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  maxLength: 500,
                  maxLines: 5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text("Report Reason"),
                  ],
                ),
              ),
              TextField(
                controller: _reportController,
                decoration: const InputDecoration(
                  hintText: "Report reason text",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
                maxLength: 100,
                maxLines: 3,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text("Report reason applies to:"),
                  ],
                ),
              ),
              RadioListTile(
                title: const Text("Posts and comments"),
                value: 'P&C',
                groupValue: _reportReason,
                onChanged: (value) {
                  setState(
                    () {
                      _reportReason = value.toString();
                    },
                  );
                },
              ),
              RadioListTile(
                title: const Text("Only comments"),
                value: 'comments',
                groupValue: _reportReason,
                onChanged: (value) {
                  setState(
                    () {
                      _reportReason = value.toString();
                    },
                  );
                },
              ),
              RadioListTile(
                title: const Text("Only posts"),
                value: 'posts',
                groupValue: _reportReason,
                onChanged: (value) {
                  setState(
                    () {
                      _reportReason = value.toString();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
