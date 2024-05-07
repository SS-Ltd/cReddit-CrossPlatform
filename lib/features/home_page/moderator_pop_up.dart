import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/theme.dart';
import 'package:reddit_clone/services/networkServices.dart';

class ModeratorPopUP extends StatelessWidget {
  final PostModel postModel;
  const ModeratorPopUP({required this.postModel, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Semantics(
              label: 'Approve post',
              child: ArrowButton(
                  onPressed: () async {
                    bool isApproved = await context
                        .read<NetworkService>()
                        .approvePost(postModel.postId, true);
                    Navigator.pop(context);
                  },
                  buttonText: "Approve post",
                  buttonIcon: Icons.check,
                  hasarrow: false),
            ),
            Semantics(
              label: 'Remove post',
              child: ArrowButton(
                  onPressed: () async {
                    bool isRemoved = await context
                        .read<NetworkService>()
                        .removePost(postModel.postId, true);
                    Navigator.pop(context, 'removed');
                  },
                  buttonText: "Remove post",
                  buttonIcon: Icons.remove_circle_outline,
                  hasarrow: false),
            ),
            Semantics(
              label: 'Remove as spam',
              child: ArrowButton(
                  onPressed: () async {
                    bool isRemoved = await context
                        .read<NetworkService>()
                        .removePost(postModel.postId, true);
                    Navigator.pop(context, 'removed');
                  },
                  buttonText: "Remove as spam",
                  buttonIcon: Icons.remove_from_queue_outlined,
                  hasarrow: false),
            ),
            Semantics(
              label: 'Lock comments',
              child: ArrowButton(
                  onPressed: () async {
                    bool isLocked = await context
                        .read<NetworkService>()
                        .lockpost(postModel.postId, true);
                    Navigator.pop(context);
                  },
                  buttonText: "Lock comments",
                  buttonIcon: Icons.lock_outline,
                  hasarrow: false),
            ),
            // Semantics(
            //   label: 'Sticky post',
            //   child: ArrowButton(
            //       onPressed: () {},
            //       buttonText: "Sticky post",
            //       buttonIcon: Icons.push_pin_outlined,
            //       hasarrow: false),
            // ),
            Semantics(
              label: 'Mark as spoiler',
              child: ArrowButton(
                  onPressed: () async {
                    bool isMarked = await context
                        .read<NetworkService>()
                        .markAsSpoiler(postModel.postId, true);
                    Navigator.pop(context);
                  },
                  buttonText: "Mark as spoiler",
                  buttonIcon: Icons.warning_amber_outlined,
                  hasarrow: false),
            ),
            Semantics(
              label: 'Mark as NSFW',
              child: ArrowButton(
                  onPressed: () async {
                    bool isMarked = await context
                        .read<NetworkService>()
                        .markAsNSFW(postModel.postId, true);
                    Navigator.pop(context);
                  },
                  buttonText: "Mark as NSFW",
                  buttonIcon: Icons.eighteen_up_rating_outlined,
                  hasarrow: false),
            ),
            // Semantics(
            //   label: 'Adjust Croud Control',
            //   child: ArrowButton(
            //       onPressed: () {},
            //       buttonText: "Adjust Croud Control",
            //       buttonIcon: Icons.group_outlined,
            //       hasarrow: false),
            // ),
          ],
        ),
      ),
    );
  }
}
