// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reddit_clone/lib/models/user_model.dart';

// void followUser({
//     required UserModel user,
//     required BuildContext context,
//     required UserModel currentUser,
//   }) async {
//     // already following
//     if (currentUser.following.contains(user.uid)) {
//       user.followers.remove(currentUser.uid);
//       currentUser.following.remove(user.uid);
//     } else {
//       user.followers.add(currentUser.uid);
//       currentUser.following.add(user.uid);
//     }

//     user = user.copyWith(followers: user.followers);
//     currentUser = currentUser.copyWith(
//       following: currentUser.following,
//     );

//     final res = await _userAPI.followUser(user);
//     res.fold((l) => showSnackBar(context, l.message), (r) async {
//       final res2 = await _userAPI.addToFollowing(currentUser);
//       res2.fold((l) => showSnackBar(context, l.message), (r) {
//         _notificationController.createNotification(
//           text: '${currentUser.name} followed you!',
//           postId: '',
//           notificationType: NotificationType.follow,
//           uid: user.uid,
//         );
//       });
//     });
//   }