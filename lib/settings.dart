import 'package:flutter/material.dart';
import 'package:reddit_clone/account_settings.dart';
import 'package:reddit_clone/arrow_button.dart';
import 'package:reddit_clone/heading.dart';
import 'package:reddit_clone/selection_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Heading(text: 'General'),
              ArrowButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccountSettings()));
                  },
                  buttonText: 'Account Settings for u/ (username)',
                  buttonIcon: Icons.person),
              const Heading(text: 'Premium'),
              const Heading(text: 'Language'),
              SelectionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const Column(
                          children: [
                            Row(
                              children: [Text('Language')],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  buttonText: 'App Language',
                  buttonIcon: Icons.translate,
                  selectedtext: 'English'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Content Language',
                  buttonIcon: Icons.translate,),
              const Heading(text: 'View Options'),
              const Heading(text: 'Accessibility'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Increase Text Size',
                  buttonIcon: Icons.text_fields),
              const Heading(text: 'Dark Mode'),
              const Heading(text: 'Advanced'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Export video log',
                  buttonIcon: Icons.help_outline),
              const Heading(text: 'About'),
              ArrowButton(
                  onPressed: () => setState(() {
                        launchUrl(
                            Uri.parse(
                                'https://www.redditinc.com/policies/content-policy'),
                            mode: LaunchMode.externalApplication);
                      }),
                  buttonText: 'Content Policy',
                  buttonIcon: Icons.description_outlined),
              ArrowButton(
                  onPressed: () => setState(() {
                        launchUrl(
                            Uri.parse(
                                'https://www.reddit.com/policies/privacy-policy'),
                            mode: LaunchMode.externalApplication);
                      }),
                  buttonText: 'Privacy Policy',
                  buttonIcon: Icons.privacy_tip),
              ArrowButton(
                  onPressed: () => setState(() {
                        launchUrl(
                            Uri.parse(
                                'https://www.redditinc.com/policies/user-agreement'),
                            mode: LaunchMode.externalApplication);
                      }),
                  buttonText: 'User Agreement',
                  buttonIcon: Icons.person),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Acknowledgments',
                  buttonIcon: Icons.description),
              const Heading(text: 'Support'),
              ArrowButton(
                  onPressed: () => setState(() {
                        launchUrl(
                            Uri.parse(
                                'https://support.reddithelp.com/hc/en-us'),
                            mode: LaunchMode.externalApplication);
                      }),
                  buttonText: 'Help Center',
                  buttonIcon: Icons.help_outline),
              ArrowButton(
                  onPressed: () => setState(() {
                        launchUrl(
                            Uri.parse(
                                'https://www.reddit.com/r/redditmobile/s/Nc8FRHZvS4'),
                            mode: LaunchMode.externalApplication);
                      }),
                  buttonText: 'Visit r/redditmobile',
                  buttonIcon: Icons.reddit),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Report an issue',
                  buttonIcon: Icons.email_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
