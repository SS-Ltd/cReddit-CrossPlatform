import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotateMultiple,
          colors: [Palette.blueColor],
          strokeWidth: 1,
        ),
      ),
    );
  }
}