import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({super.key});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isFollowing = false;
  bool _isLoading = false;

  void _toggleFollow() {
    setState(() {
      _isLoading = true; // Start the loading animation
    });

    // Simulate a network call or some asynchronous task
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isFollowing = !_isFollowing;
        _isLoading = false; // Stop the loading animation

        if (_isFollowing) {
          // Show Snackbar if followed
          _showFollowedSnackbar();
        } else {
          // Show Snackbar if unfollowed
          _showUnfollowedSnackbar();
        }
      });
    });
  }

  void _showFollowedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SlideInSnackBar(
          content: 'Following user!',
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green[800]!,
          textColor: Colors.white,
        ),
      ),
    );
  }

  void _showUnfollowedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: SlideInSnackBar(
          content: 'You are no longer following this user.',
          duration: Duration(seconds: 1),
          backgroundColor: Colors.white,
          textColor: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.white;

    return ElevatedButton(
      onPressed: _isLoading ? null : _toggleFollow,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: borderColor, width: 3.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        ),
      ),
      child: _isLoading
          ? const SizedBox( // Hide the text when loading
              height: 24.0,
              width: 24.0,
              child: SpinKitCircle(
                color: Colors.white,
                size: 24.0,
              ),
            )
          : Text(
              _isFollowing ? '✓ Following' : 'Follow',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
    );
  }
}

class SlideInSnackBar extends StatefulWidget {
  final String content;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;

  const SlideInSnackBar({super.key, 
    required this.content,
    required this.duration,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  _SlideInSnackBarState createState() => _SlideInSnackBarState();
}

class _SlideInSnackBarState extends State<SlideInSnackBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
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