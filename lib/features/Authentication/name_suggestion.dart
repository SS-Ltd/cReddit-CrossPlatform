import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cReddit/common/FullWidthButton.dart';
import 'package:cReddit/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cReddit/features/Authentication/widgets/auth_filed.dart';
import 'package:cReddit/theme/palette.dart';
import 'package:cReddit/features/Authentication/gender.dart';
import 'package:cReddit/services/networkServices.dart'; // Import NetworkServices

class NameSuggestion extends StatefulWidget {
  final Map<String, dynamic> userData;
  NameSuggestion({Key? key, required this.userData}) : super(key: key);

  @override
  _NameSuggestionState createState() => _NameSuggestionState();
}

class _NameSuggestionState extends State<NameSuggestion> {
  final TextEditingController usernameController = TextEditingController();

  List<String> usernameSuggestions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch and populate usernameSuggestions with random names
    generateRandomNames();
  }

  // Function to generate 5 random names and add them to usernameSuggestions
  void generateRandomNames() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<String> randomNames = [];
      for (int i = 0; i < 5; i++) {
        String randomName =
            await context.read<NetworkService>().getRandomName();
        randomNames.add(randomName);
      }
      setState(() {
        usernameSuggestions = randomNames;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching random names: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Palette.redditLogin,
      appBar: AppBar(
        backgroundColor: Palette.redditLogin,
        title: SvgPicture.asset(
          AssetsConstants.redditLogo,
          width: 50,
          height: 50,
        ),
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
                  // List of suggestions or loading indicator
                  Expanded(
                    child: SingleChildScrollView(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: usernameSuggestions.length,
                                  itemBuilder: (context, index) {
                                    final suggestion =
                                        usernameSuggestions[index];
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
                                // Generate Again button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        generateRandomNames();
                                      },
                                      child: Text(
                                        'Generate Again',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
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
                  widget.userData['username'] = usernameController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Gender(userData: widget.userData)),
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
