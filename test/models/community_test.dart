import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/community.dart';

void main() {
    group('Community', () {
        final json = {
            'name': 'Test Community',
            'icon': 'https://example.com/icon.png',
            'members': 100,
            'description': 'This is a test community.',
            'isJoined': true,
        };

        final community = Community(
            name: 'Test Community',
            icon: 'https://example.com/icon.png',
            members: 100,
            description: 'This is a test community.',
            isJoined: true,
        );

        test('fromJson', () {
            expect(Community.fromJson(json), community);
        });

        test('toString', () {
            expect(
                community.toString(),
                'Community{name: Test Community, members: 100, description: This is a test community., icon: https://example.com/icon.png, isJoined: true}',
            );
        });

        test('==', () {
            expect(
                community == Community.fromJson(json),
                true,
            );
        });

        test('hashCode', () {
            expect(
                community.hashCode,
                community.name.hashCode ^
                        community.members.hashCode ^
                        community.description.hashCode ^
                        community.icon.hashCode ^
                        community.isJoined.hashCode,
            );
        });
    });
}