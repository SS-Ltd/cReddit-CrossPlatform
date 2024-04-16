import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/utils/utils_time.dart';

void main() {
  test('Check Time Stamp Format', () {
    final postTime = DateTime.now().subtract(const Duration(days: 2));
    String result = formatTimestamp(postTime); 
    expect(result, '2d');
    final postTime1 = DateTime.now().subtract(const Duration(hours: 1));
    String result1 = formatTimestamp(postTime1); 
    expect(result1, '1h');
    final postTime2 = DateTime.now().subtract(const Duration(minutes: 6));
    String result2 = formatTimestamp(postTime2); 
    expect(result2, '6m');
  });  
}