import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';
import 'package:reddit_clone/features/home_page/home_page.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

class DeletePostPopUp extends StatelessWidget {
  const DeletePostPopUp({super.key, required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Are you sure?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Text("You cannot restore posts that have been deleted."),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
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
                      bool isDeleted = await context
                          .read<NetworkService>()
                          .deletepost(postId);
                      if (isDeleted) {
                        CustomSnackBar(
                                content: "Post deleted!",
                                context: context,
                                backgroundColor: Colors.white,
                                textColor: Colors.black)
                            .show();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomNavigationBar(isProfile: false,)),
                            (route) => false);
                      } else {
                        CustomSnackBar(
                                content: "Failed to delete the post.",
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
                    child: const Text("Delete"),
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
