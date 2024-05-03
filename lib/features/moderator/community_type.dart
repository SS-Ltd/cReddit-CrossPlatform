import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/theme.dart';

class CommunityType extends StatefulWidget {
  const CommunityType({super.key});

  @override
  State<CommunityType> createState() {
    return _CommunityTypeState();
  }
}

class _CommunityTypeState extends State<CommunityType> {
  double _sliderValue = 0.0;
  bool switchvalue = false;
  bool communityvalue = false;
  double levelofvisibility = 0.0;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Community Type'),
          actions: [
            ElevatedButton(
              onPressed: (communityvalue != switchvalue ||
                      levelofvisibility != _sliderValue)
                  ? () {}
                  : null,
              child: const Text("Save"),
            ),
          ],
        ),
        body: Column(
          children: [
            Slider(
              value: _sliderValue,
              min: 0,
              max: 1,
              divisions: 2,
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
              activeColor: _sliderValue == 0
                  ? Colors.green
                  : _sliderValue == 0.5
                      ? Colors.yellow
                      : Colors.red,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Row(
                children: [
                  _sliderValue == 0
                      ? const Text(
                          'Public',
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        )
                      : _sliderValue == 0.5
                          ? const Text(
                              'Restricted',
                              style:
                                  TextStyle(color: Colors.yellow, fontSize: 20),
                            )
                          : const Text(
                              'Private',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 360,
                    child: Text(
                      _sliderValue == 0
                          ? 'Anyone can see and participate in this community.'
                          : _sliderValue == 0.5
                              ? 'Anyone can see, join, or vote in this community, but you control who posts and comments.'
                              : 'Only people you approve can see and participate in this community.',
                      softWrap: true,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        switchvalue = !switchvalue;
                      });
                    },
                    child: const Text(
                      "18+ community",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Palette.whiteColor),
                    ),
                  ),
                  Switch(
                      value: switchvalue,
                      onChanged: (value) {
                        setState(() {
                          switchvalue = value;
                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
