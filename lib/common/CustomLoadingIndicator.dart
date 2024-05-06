import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color color;
  const CustomLoadingIndicator({super.key, this.color = Palette.blueColor});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotateMultiple,
          colors: [color],
          strokeWidth: 1,
        ),
      ),
    );
  }
}