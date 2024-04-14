import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/utils/utils_time.dart';

void main() {
  test('Check Time Stamp Format', () {
    final postTime = DateTime(2024, 3, 17);
    String result = formatTimestamp(postTime);
    expect(result, '2d');
    final postTime1 = DateTime(2024, 3, 19, 1);
    String result1 = formatTimestamp(postTime1);
    expect(result1, '2h');
    final postTime2 = DateTime(2024, 3, 19, 3, 10);
    String result2 = formatTimestamp(postTime2);
    expect(result2, '9m');
  });
}
