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
        name: 'Sandrine_Kuhic',
        icon: 'https://picsum.photos/seed/sBHDq9/640/480',
        members: 9,
        description:
            'Absens amplitudo animus atrocitas sui. Modi audeo ocer solitudo verecundia cogo tenus modi vereor. Laborum aetas absum stella tergiversatio.',
        isJoined: false,
      ),
      Community(
        name: 'Karelle_Brown73',
        icon: 'https://picsum.photos/seed/h2XebzN/640/480',
        members: 8,
        description:
            'Toties debitis auditor alienus decimus facilis. Dicta acsi aliquid velit adeo tantillus audeo stabilis ratione. Creta unde curatio cohibeo currus chirographum cui appono volubilis.',
        isJoined: false,
      ),
      Community(
        name: 'Schuyler.Schamberger62',
        icon: 'https://picsum.photos/seed/fPl2qC/640/480',
        members: 7,
        description:
            'Acsi appositus caute repellat creber vero certus capto. Architecto adeptio villa admitto utilis. Molestiae abeo soleo crapula volva decimus vulgivagus decens.',
        isJoined: false,
      ),
    ];

    expect(communities.take(3).toList(), equals(expectedCommunities));
  });
}
