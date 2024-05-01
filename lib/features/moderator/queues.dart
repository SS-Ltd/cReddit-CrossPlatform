import 'package:flutter/material.dart';

class Queues extends StatefulWidget{
  const Queues({Key? key}) : super(key: key);

  @override
  State<Queues> createState() {
    return _QueuesState();
  }
}

class _QueuesState extends State<Queues>{

  String _selectedQueue = "Queues";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton.icon(
          onPressed: () {
            
          },
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          label: Text(_selectedQueue),
        ),
        title: const Text("Queues"),
      ),
      body: const Center(
        child: Text("Queues"),
      ),
    );
  }

}