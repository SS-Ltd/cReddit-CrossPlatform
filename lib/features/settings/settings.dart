import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/settings/account_settings.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/common/heading.dart';
import 'package:reddit_clone/selection_button.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String currentlanguage = 'English';

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
              ArrowButton(
                onPressed: () {},
                buttonText: 'Get Premium',
                buttonIcon: Icons.shield,
              ),
              ArrowButton(
                onPressed: () {},
                buttonText: 'Change app icon',
                buttonIcon: Icons.reddit,
              ),
              ArrowButton(
                onPressed: () {},
                buttonText: 'Create Avatar',
                buttonIcon: Icons.android,
              ),
              const Heading(text: 'Language'),
              SelectionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: BottomSheet(
                            onClosing: () {},
                            builder: (context) => Column(
                              children: [
                                ListTile(
                                  title: const Text('English'),
                                  onTap: () {
                                    setState(() {
                                      currentlanguage = 'English';
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: const Text('Spanish'),
                                  onTap: () {
                                    setState(() {
                                      currentlanguage = 'Spanish';
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: const Text('French'),
                                  onTap: () {
                                    setState(() {
                                      currentlanguage = 'French';
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  buttonText: 'App Language',
                  buttonIcon: Icons.translate,
                  selectedtext: currentlanguage),
              ArrowButton(
                onPressed: () {},
                buttonText: 'Content Language',
                buttonIcon: Icons.translate,
              ),
              const Heading(text: 'View Options'),
              SelectionButton(
                  onPressed: () {},
                  buttonText: 'Default view',
                  buttonIcon: Icons.view_stream_outlined,
                  selectedtext: 'Card'),
              SelectionButton(
                  onPressed: () {},
                  buttonText: 'Autoplay',
                  buttonIcon: Icons.play_arrow_outlined,
                  selectedtext: 'Always'),
              SelectionButton(
                  onPressed: () {},
                  buttonText: 'Thumbnails',
                  buttonIcon: Icons.image_outlined,
                  selectedtext: 'Community default'),
              const Heading(text: 'Accessibility'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Increase Text Size',
                  buttonIcon: Icons.text_fields),
              const Heading(text: 'Dark Mode'),
              SelectionButton(
                  onPressed: () {},
                  buttonText: 'Auto Dark Mode',
                  buttonIcon: Icons.settings,
                  selectedtext: 'Follow OS settings'),
              SelectionButton(
                  onPressed: () {},
                  buttonText: 'Light theme',
                  buttonIcon: Icons.light_mode_outlined,
                  selectedtext: 'Alien Blue'),
              SelectionButton(
                  onPressed: () {},
                  buttonText: 'Dark theme',
                  buttonIcon: Icons.dark_mode_outlined,
                  selectedtext: 'Night'),
              const Heading(text: 'Advanced'),
              SelectionButton(
                  onPressed: () {},
                  buttonText: 'Default comment sort',
                  buttonIcon: Icons.mode_comment_outlined,
                  selectedtext: 'Best'),
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
