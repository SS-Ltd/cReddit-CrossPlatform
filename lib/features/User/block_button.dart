import 'package:flutter/material.dart';

/// A button widget that can be used to block a user.
class BlockButton extends StatelessWidget {
  final bool isCircular;
  final VoidCallback onPressed;

  /// Creates a [BlockButton].
  ///
  /// The [isCircular] parameter determines whether the button should be circular or not.
  /// The [onPressed] parameter is a callback function that will be called when the button is pressed.
  const BlockButton({
    super.key,
    required this.isCircular,
    required this.onPressed,
  });

  /// Shows a snackbar with a block message.
  void _showBlockSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: SlideInSnackBar(
          content: 'Username was blocked',
          duration: Duration(seconds: 1),
          backgroundColor: Colors.white,
          textColor: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isCircular
        ? _buildCircularButton(context)
        : _buildBarButton(context);
  }

  /// Builds a circular button.
  Widget _buildCircularButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        shape: const CircleBorder(),
      ),
      child: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(Icons.block, color: Colors.white, size: 24.0),
      ),
    );
  }

  /// Builds a bar button.
  Widget _buildBarButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.black.withOpacity(0.2),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.block, color: Colors.white),
          SizedBox(width: 8.0),
          Text('Block Account', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

/// A dialog widget that confirms the blocking action.
class BlockConfirmationDialog extends StatelessWidget {
  /// Creates a [BlockConfirmationDialog].
  const BlockConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Are you Sure?',
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You won\'t see posts or comments from this user.',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.grey[800]!,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
                child: const Text('CANCEL'),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Perform block action
                  void _showBlockSnackbar(BuildContext context) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.white,
                      content: const Text(
                        'User has been blocked',
                        style: TextStyle(color: Colors.black),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  _showBlockSnackbar(context);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
                child: const Text('BLOCK'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A snackbar widget that slides in from the bottom.
class SlideInSnackBar extends StatefulWidget {
  final String content;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;

  /// Creates a [SlideInSnackBar].
  ///
  /// The [content] parameter is the text content of the snackbar.
  /// The [duration] parameter is the duration for which the snackbar will be displayed.
  /// The [backgroundColor] parameter is the background color of the snackbar.
  /// The [textColor] parameter is the text color of the snackbar.
  const SlideInSnackBar({
    super.key,
    required this.content,
    required this.duration,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<SlideInSnackBar> createState() {
    return _SlideInSnackBarState();
  }
}

class _SlideInSnackBarState extends State<SlideInSnackBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      )),
      child: Material(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            widget.content,
            style: TextStyle(color: widget.textColor),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
