import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/utils/utils_votemap.dart';


void main() {
  test('mappingVotes returns 1 when isUpvoted is true', () {
    expect(mappingVotes(true, false), 1);
  });

  test('mappingVotes returns -1 when isDownvoted is true', () {
    expect(mappingVotes(false, true), -1);
  });

  test('mappingVotes returns 0 when both isUpvoted and isDownvoted are false', () {
    expect(mappingVotes(false, false), 0);
  });
}