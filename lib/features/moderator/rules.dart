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
      body: rules.isEmpty ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
          ],),
      ) : Column(),
    );
  }
}
