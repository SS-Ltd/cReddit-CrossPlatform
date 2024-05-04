import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/models/community.dart';

void main() {
  test('fetchCommunities returns a list of communities', () async {
    // Create an instance of NetworkService.
    final networkService = NetworkService();

    final communities = await networkService.fetchTopCommunities();

    // Replace the following with your expected output.
    final expectedCommunities = [
      Community(
        name: 'Annamae.Rohan10',
        icon: 'https://loremflickr.com/640/480?lock=4497597033086976',
        members: 99,
        description:
            'Sunt capio vapulus deorsum ultio comburo validus defessus. Ait caritas utique earum sumptus bibo assentator. Sulum vitae laborum pauper pax aestas ipsum currus nam caute.',
        isJoined: false,
      ),
      Community(
        name: 'Carlotta.Kreiger61',
        icon: 'https://loremflickr.com/640/480?lock=3683531003789312',
        members: 94,
        description:
            'Qui absum aiunt vehemens cernuus cenaculum accendo alveus occaecati bonus. Voluptate arbitro caste celo quaerat concedo. Summa strues vereor spero.',
        isJoined: false,
      ),
      Community(
        name: 'Petra.Hilpert',
        icon: 'https://loremflickr.com/640/480?lock=3105074939166720',
        members: 81,
        description:
            'Laborum alias tabula surculus campana. Porro commodo numquam vulgo surgo undique voluptas. Facilis caste incidunt ventus tergiversatio conculco temperantia adaugeo ipsum taceo.',
        isJoined: false,
      ),
    ];

    expect(communities.take(3).toList(), equals(expectedCommunities));
  });
}
