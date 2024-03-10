import 'package:flutter/material.dart';
import 'package:reddit_clone/arrow_button.dart';
import 'package:reddit_clone/heading.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
                  onPressed: () {},
                  buttonText: 'Account Settings for u/ (username)',
                  buttonicon: Icons.person),
              const Heading(text: 'Premium'),
              const Heading(text: 'Language'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Content Language',
                  buttonicon: Icons.translate),
              const Heading(text: 'View Options'),
              const Heading(text: 'Accessibility'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Increase Text Size',
                  buttonicon: Icons.text_fields),
              const Heading(text: 'Dark Mode'),
              const Heading(text: 'Advanced'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Export video log',
                  buttonicon: Icons.help_outline),
              const Heading(text: 'About'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Content Policy',
                  buttonicon: Icons.description_outlined),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Privacy Policy',
                  buttonicon: Icons.privacy_tip),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'User Agreement',
                  buttonicon: Icons.person),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Acknowledgments',
                  buttonicon: Icons.description),
              const Heading(text: 'Support'),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Help Center',
                  buttonicon: Icons.help_outline),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Visit r/redditmobile',
                  buttonicon: Icons.reddit),
              ArrowButton(
                  onPressed: () {},
                  buttonText: 'Report an issue',
                  buttonicon: Icons.email_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
