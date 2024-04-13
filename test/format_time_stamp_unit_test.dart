import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/home_page/post.dart';

void main() {
  test('Check Time Stamp Format', () {
    final postTime = DateTime(2024, 3, 17);
    String result = formatTimestamp(postTime); 
    expect(result, '2d');
    final postTime1 = DateTime(2024, 3, 19, 1);
    String result1 = formatTimestamp(postTime1); 
    expect(result1, '1h');
    final postTime2 = DateTime(2024, 3, 19, 2, 48);
    String result2 = formatTimestamp(postTime2); 
    expect(result2, '6m');
  });  
}