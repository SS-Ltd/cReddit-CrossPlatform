import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

class BlockPopUp extends StatelessWidget {
  final String userName;

  const BlockPopUp({required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Block u/$userName?",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Text("They won't be able to contact you or view your profile, posts or comments."),
          Padding(
            padding: const EdgeInsets.only(top: 10,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel")),
                ),
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isBlocked =
                          await context.read<NetworkService>().blockUser(userName);
                          print(isBlocked);
                          print(userName);
                      if (isBlocked) {
                        CustomSnackBar(
                                content:
                                    "The Author of this post has been blocked.",
                                context: context,
                                backgroundColor: Colors.white,
                                textColor: Colors.black)
                            .show();
                        Navigator.of(context).pop();
                      } else {
                        CustomSnackBar(
                                content: "Failed to block the user.",
                                context: context,
                                backgroundColor: Colors.white,
                                textColor: Colors.black)
                            .show();
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text("Block Account"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
