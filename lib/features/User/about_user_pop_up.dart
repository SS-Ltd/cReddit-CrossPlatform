import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/features/User/Profile.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/NetworkServices.dart';

class AboutUserPopUp extends StatelessWidget {
  final String userName;

  const AboutUserPopUp({required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('u/$userName'),
                ],
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
                    onPressed: () async {
                      UserModel myUser = await context
                          .read<NetworkService>()
                          .getUserDetails(userName);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            userName: myUser.username,
                            profileName: myUser.username,
                            displayName: myUser.displayName,
                            profilePicture: myUser.profilePicture,
                            followerCount: myUser.followers,
                            about: myUser.about!,
                            cakeDay: myUser.cakeDay.toString(),
                            bannerPicture: myUser.banner!,
                            isOwnProfile: true,
                          ),
                        ),
                      );
                    },
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
          ),
    );
  }
}

//actions in dialog box
  