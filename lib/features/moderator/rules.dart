import 'package:flutter/material.dart';

class Rules extends StatefulWidget {
  const Rules({super.key});

  @override
  State<Rules> createState() {
    return _RulesState();
  }
}

class _RulesState extends State<Rules> {
  List<String> rules = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        title: Column(
          children: [const Text("Rules"), Text("${rules.length}//15 rules")],
        ),
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
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text("Create rules for r/"),
                      Text("community name"),
                    ],
                  ),
                ),
              ],
            )
          : Column(),
    );
  }
}
