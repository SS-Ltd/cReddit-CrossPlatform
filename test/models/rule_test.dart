import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/rule.dart';

void main() {
  group('SubredditRule', () {
    test('fromJson should create a SubredditRule from JSON', () {
      var json = {
        'text': 'Test Text',
        'appliesTo': 'Test AppliesTo',
        '_id': '1',
      };

      var subredditRule = SubredditRule.fromJson(json);

      expect(subredditRule.text, equals('Test Text'));
      expect(subredditRule.appliesTo, equals('Test AppliesTo'));
      expect(subredditRule.id, equals('1'));
    });
  });
}
