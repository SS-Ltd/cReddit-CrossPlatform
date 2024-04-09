import 'package:flutter/material.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/Authentication/widgets/auth_filed.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/features/Authentication/Gender.dart';

class NameSuggestion extends StatelessWidget {
  NameSuggestion({super.key});
  final TextEditingController usernameController = TextEditingController();

  // Mock list of suggestions
  final List<String> usernameSuggestions = [
    'user1',
    'user2',
    'user3',
    'user4',
    'user5',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: Palette.redditLogin,
      appBar: AppBar(
        backgroundColor: Palette.redditLogin,
        title:
            SvgPicture.asset(AssetsConstants.redditLogo, width: 50, height: 50),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Create your username',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Palette.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Most redditors use an anonymous username." 
                    " You won't be able to change your username later.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  AuthField(
                    controller: usernameController,
                    labelText: 'Username',
                  ),
                  const SizedBox(height: 20),
                  // List of suggestions
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: usernameSuggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = usernameSuggestions[index];
                              return ListTile(
                                title: Text(suggestion),
                                onTap: () {
                                  // Set the username from suggestion
                                  usernameController.text = suggestion;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Only show the button if the keyboard is closed
            Visibility(
              visible: !isKeyboardOpen,
              child: FullWidthButton(
                text: "Continue",
                onPressed: () async {
                  if (usernameController.text.isEmpty) {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Gender()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
