import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('User Profile'),
              background: Image.network(
                'https://picsum.photos/250?image=9',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: ListView(
        children: const [
          ListTile(
            title: Text('User Name'),
            subtitle: Text('userModel.name'),
          ),
          ListTile(
            title: Text('User Email'),
            subtitle: Text('userModel.email'),
          ),
          ListTile(
            title: Text('User Bio'),
            subtitle: Text('userModel.bio'),
          ),
          ListTile(
            title: Text('Followers'),
            subtitle: Text('userModel.followers.length.toString()'),
          ),
          ListTile(
            title: Text('Following'),
            subtitle: Text('userModel.following.length.toString()'),
          ),
        ],
      ),
    );
  }
}