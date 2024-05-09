import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/joined_communities.dart';

void main() {
  group('JoinedCommunities', () {
    test('fromJson should create a JoinedCommunities from JSON', () {
      var json = {
        'members': 100,
        'profilePicture': 'https://example.com/image.jpg',
        'communityName': 'Community1',
      };

      var joinedCommunities = JoinedCommunitites.fromJson(json);

      expect(joinedCommunities.members, equals(100));
      expect(joinedCommunities.profilePicture,
          equals('https://example.com/image.jpg'));
      expect(joinedCommunities.name, equals('Community1'));
    });
  });
}
