import 'package:flutter/material.dart';

class AddRule extends StatefulWidget {
  const AddRule({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close),
          ),
          title: const Text("Create rule"),
          actions: [
            ElevatedButton(
              onPressed: _istitleempty ? null : () {},
              child: const Text("Save"),
            ),
          ],
        ),
        body: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title*",
                hintText: "Rule title",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding: const EdgeInsets.all(10),
              ),
              maxLength: 100,
              onChanged: (value) {
                setState(
                  () {
                    _istitleempty = value.isEmpty;
                  },
                );
              },
            ),
            SizedBox(
              height: 100,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Rule description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  contentPadding: const EdgeInsets.all(10),
                ),
                maxLength: 500,
                maxLines: 5,
              ),
            ),
            TextField(
              controller: _reportController,
              decoration: InputDecoration(
                labelText: "Report Reason",
                hintText: "Report reason text",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding: const EdgeInsets.all(10),
              ),
              maxLength: 100,
              maxLines: 2,
            ),
            const Text("Report reason applies to:"),
          ],
        ),
      ),
    );
  }
}
