import 'package:flutter/material.dart';


class BlockButton extends StatelessWidget {
  final bool isCircular;
  final VoidCallback onPressed;

  const BlockButton({
    Key? key,
    required this.isCircular,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCircular
        ? _buildCircularButton()
        : _buildBarButton(context);
  }

  Widget _buildCircularButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.all(8.0),
        shape: CircleBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0), // Adjusted padding
        child: Icon(Icons.block, color: Colors.white, size: 24.0), // Adjusted size
      ),
    );
  }

  Widget _buildBarButton(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
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
          EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        ),
      ),
      child: Row(
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

class BlockConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        'Are you Sure?',
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You won\'t see posts or comments from this user.',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
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
                child: Text('CANCEL'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Perform block action
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
                child: Text('BLOCK'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
