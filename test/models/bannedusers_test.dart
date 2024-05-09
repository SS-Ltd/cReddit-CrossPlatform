import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/bannedusers.dart';

void main() {
  group('BannedUserList', () {
    test('fromJson should create a BannedUserList from JSON', () {
      var json = {
        'bannedUsers': [
          {
            'username': 'User1',
            'reasonToBan': 'Reason1',
            'modNote': 'Note1',
            'days': 1,
          },
          {
            'username': 'User2',
            'reasonToBan': 'Reason2',
            'days': 0,
          },
        ],
      };

      var bannedUserList = BannedUserList.fromJson(json);

      expect(bannedUserList.bannedUsers[0].name, equals('User1'));
      expect(bannedUserList.bannedUsers[0].reasonToBan, equals('Reason1'));
      expect(bannedUserList.bannedUsers[0].modNote, equals('Note1'));
      expect(bannedUserList.bannedUsers[0].days, equals(1));
      expect(bannedUserList.bannedUsers[1].name, equals('User2'));
      expect(bannedUserList.bannedUsers[1].reasonToBan, equals('Reason2'));
      expect(bannedUserList.bannedUsers[1].modNote, isNull);
      expect(bannedUserList.bannedUsers[1].days, equals(0));
    });
  });

  group('BannedUser', () {
    test('fromJson should create a BannedUser from JSON', () {
      var json = {
        'username': 'User1',
        'reasonToBan': 'Reason1',
        'modNote': 'Note1',
        'days': 1,
      };

      var bannedUser = BannedUser.fromJson(json);

      expect(bannedUser.name, equals('User1'));
      expect(bannedUser.reasonToBan, equals('Reason1'));
      expect(bannedUser.modNote, equals('Note1'));
      expect(bannedUser.days, equals(1));
    });
  });
}
