import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/home_page/post.dart';

void main() {
  test('Test isImage function', () {
    // Test with valid image URLs
    expect(isImage('example.jpg'), true);
    expect(isImage('example.jpeg'), true);
    expect(isImage('example.png'), true);
    expect(isImage('example.gif'), true);

    // Test with invalid image URLs
    expect(isImage('example.mp4'), false);
    expect(isImage('example.webm'), false);
    expect(isImage('example.ogg'), false);
    expect(isImage('example.txt'), false);
  });
}