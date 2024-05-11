import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/utils/utils_link.dart';

void main() {
  
  test('Check is the string is a valid link format', () {
    const link = 'https://www.reddit.com/r/FlutterDev/comments/rg4z9e/flutter_2_10_release_notes/';
    bool result = linkFormat(link);
    expect(result, true);
    const link1 = 'https://www.reddit.com/r/FlutterDev/comments/rg4z9e/flutter_2_10_release_notes';
    bool result1 = linkFormat(link1);
    expect(result1, true);
    const link2 = 'https://wwwreddit/r/FlutterDev/comments/rg4z9e/flutter_2_10_release_notes/';
    bool result2 = linkFormat(link2);
    expect(result2, false);
    const link3 = 'https://reddit./r/FlutterDev/comments/rg4z9e/flutter_2_10_release_notes/';
    bool result3 = linkFormat(link3);
    expect(result3, false);
    const link4 = '://www.redditcom/r/FlutterDev/comments/rg4z9e/flutter_2_10_release_notes/';
    bool result4 = linkFormat(link4);
    expect(result4, false);
  });
}