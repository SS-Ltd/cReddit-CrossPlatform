import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/home_page/post.dart';

void main() {
  test('Test isVideo function', () {
    // Test with valid video URLs
    expect(isVideo('example.mp4'), true);
    expect(isVideo('example.webm'), true);
    expect(isVideo('example.ogg'), true);

    // Test with invalid video URLs
    expect(isVideo('example.jpg'), false);
    expect(isVideo('example.jpeg'), false);
    expect(isVideo('example.png'), false);
    expect(isVideo('example.gif'), false);
    expect(isVideo('example.txt'), false);
  });
}