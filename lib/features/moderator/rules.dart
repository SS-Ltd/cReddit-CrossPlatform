import 'package:flutter/material.dart';
import 'package:reddit_clone/features/moderator/add_rule.dart';
import 'package:url_launcher/url_launcher.dart';

class Rules extends StatefulWidget {
  const Rules({super.key});

  @override
  State<Rules> createState() {
    return _RulesState();
  }
}

class _RulesState extends State<Rules> {
  List<String> rules = [];
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isEditing
            ? null
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
        title: _isEditing
            ? const Text("Edit Rules")
            : Expanded(
                child: Column(
                  children: [
                    const Text("Rules"),
                    Text(
                      "${rules.length} / 15 rules",
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
        actions: rules.isNotEmpty && !_isEditing
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const AddRule()));
                  },
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: const Icon(Icons.edit),
                ),
              ]
            : _isEditing
                ? [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: const Text("Done"))
                  ]
                : null,
      ),
      body: rules.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 200,
                    child: Image.asset(
                      'assets/rules.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Create rules for r/",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "community name",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Text(
                          "Rules help set expectations for how people should take"),
                      const Text(
                          "part in your community and help shape the community's"),
                      const Text("culture Not sure where to start?"),
                      GestureDetector(
                        onTap: () => setState(
                          () {
                            launchUrl(
                                Uri.parse(
                                    'https://support.reddithelp.com/hc/en-us/articles/15484500104212-Rules'),
                                mode: LaunchMode.externalApplication);
                          },
                        ),
                        child: const Text(
                          "Get advice from other mods",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const AddRule()));
                  },
                  child: const Text("Create Rule"),
                ),
              ],
            )
          : ListView.builder(
              //itemCount: rules.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => const AddRule(
                                      isEditing: true,
                                    )));
                      },
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      //title: Text("Rule name"),
                      subtitle: const Text('Description of the rule'),
                      trailing: _isEditing
                          ? IconButton(
                              onPressed: () {}, icon: const Icon(Icons.delete))
                          : IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_forward_ios)),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
