import 'package:flutter/material.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/common/heading.dart';

class ModeratorTools extends StatefulWidget{

  const ModeratorTools({super.key});

  @override
  State<ModeratorTools> createState() {
    return _ModeratorToolsSatet();
  }
}

class _ModeratorToolsSatet extends State<ModeratorTools> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Moderator Tools'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Heading(text: 'General'),
            ArrowButton(onPressed: () {}, buttonText: "Mod log", buttonIcon: Icons.list),
            ArrowButton(onPressed: () {}, buttonText: "Insights", buttonIcon: Icons.query_stats),
            ArrowButton(onPressed: () {}, buttonText: "Community icon", buttonIcon: Icons.reddit),
            ArrowButton(onPressed: () {}, buttonText: "Description", buttonIcon: Icons.description),

            ArrowButton(onPressed: () {}, buttonText: "Welcome message", buttonIcon: Icons.message),
            ArrowButton(onPressed: () {}, buttonText: "Topics", buttonIcon: Icons.topic),
            ArrowButton(onPressed: () {}, buttonText: "Community type", buttonIcon: Icons.lock),
            ArrowButton(onPressed: () {}, buttonText: "Post type", buttonIcon: Icons.type_specimen),




          ],
        ),
      ),
    );
  }
}