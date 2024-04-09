import 'package:flutter/material.dart';
import 'package:reddit_clone/common/arrow_button.dart';

class AboutUserPopUp extends StatelessWidget {
  const AboutUserPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog.adaptive(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('u/(username)')],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: const Text('Create Your Own Avatar'),
                    icon: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('10,111'), Text('Post Karma')],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('10,111'), Text('Comment Karma')],
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ArrowButton(
                    onPressed: () {},
                    buttonText: 'View Profile',
                    buttonIcon: Icons.person,
                    hasarrow: false),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: ArrowButton(
                    onPressed: () {},
                    buttonText: 'Send Message',
                    buttonIcon: Icons.mail_outline,
                    hasarrow: false),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: ArrowButton(
                    onPressed: () {},
                    buttonText: 'Block Account',
                    buttonIcon: Icons.person_off_outlined,
                    hasarrow: false),
              ),
            ],
          )),
    );
  }
}

//actions in dialog box
  