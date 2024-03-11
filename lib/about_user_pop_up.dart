import 'package:flutter/material.dart';
import 'package:reddit_clone/arrow_button.dart';

class AboutUserPopUp extends StatelessWidget {
  const AboutUserPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog.adaptive(
          backgroundColor: const Color(0xFFCCCCCC),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [Text('u/(username)')],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: const Text('Create Your Own Avatar'),
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [Text('10,111'), Text('Post Karma')],
                      ),
                      Column(
                        children: [Text('10,111'), Text('Comment Karma')],
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    ArrowButton(
                        onPressed: () {},
                        buttonText: 'View profile',
                        buttonIcon: Icons.person,
                        hasarrow: false),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Row(
              //     children: [
              //       ArrowButton(
              //           onPressed: () {},
              //           buttonText: 'Start chat',
              //           buttonIcon: Icons.chat_rounded,
              //           hasarrow: false),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Row(
              //     children: [
              //       ArrowButton(
              //           onPressed: () {},
              //           buttonText: 'Block Account',
              //           buttonIcon: Icons.person_off_outlined,
              //           hasarrow: false),
              //     ],
              //   ),
              // ),
            ],
          )),
    );
  }
}

//actions in dialog box
