import 'package:flutter/material.dart';
import 'post.dart';
import 'theme/app_theme.dart';
void main() {
  runApp(MaterialApp(
    theme: AppTheme.theme,
    initialRoute: '/post',
    routes: {
      '/post': (context) => Post(
        communityName: 'Entrepreneur', 
        userName: 'throwaway123',
        title: 'Escaping corporate Hell and finding freedom', 
        imageUrl: 'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
        content: 'Man, let me fucking vent for a minute. Just got out of the shittiest gig ever – being a "marketing specialist" for the supposed big boys over at Microsoft. Let me tell you, it was SHIT.', 
        timeStamp: DateTime.now()),
      },
  ));
}