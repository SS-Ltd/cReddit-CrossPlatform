import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/utils/utils_time.dart';

void main() {
  test('Check Time Stamp Format', () {
    final postTime = DateTime(2024, 4, 14);
    String result = formatTimestamp(postTime); 
    expect(result, '2d');
    final postTime1 = DateTime(2024, 4, 16, 21);
    String result1 = formatTimestamp(postTime1); 
    expect(result1, '1h');
    final postTime2 = DateTime(2024, 4, 16, 21, 54);
    String result2 = formatTimestamp(postTime2); 
    expect(result2, '5m');
  });  
}