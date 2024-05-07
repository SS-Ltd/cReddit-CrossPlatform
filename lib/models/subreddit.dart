class Subreddit {
  final String name;
  final String icon;
  final String? banner;
  final int members;
  final List<String> rules;
  final List<String> moderators;
  final String? description;
  final bool isMember;
  final bool isNSFW;
  final bool isModerator;

  Subreddit({
    required this.name,
    required this.icon,
    required this.banner,
    required this.members,
    required this.rules,
    required this.moderators,
    required this.description,
    this.isMember = false,
    this.isNSFW = false,
    required this.isModerator,
  });

  factory Subreddit.fromJson(Map<String, dynamic> json) {
    final List<String> rulesTexts = (json['rules'] as List).map((rule) {
      return rule['text'] as String; // Assuming 'text' is always a string
    }).toList();
    return Subreddit(
      name: json['name'],
      icon: json['icon'],
      banner: json['banner'],
      members: json['members'],
      rules: rulesTexts,
      moderators: (json['moderators'] as List)
          .map((user) => Moderators.fromJson(user).username)
          .toList(),
      description: json['description'] ?? '',
      isMember: json['isMember'] ?? false,
      isModerator: json['isModerator'],
      isNSFW: json['isNSFW'] ?? false,
    );
  }
}

class Moderators {
  String username;
  String profilePicture;

  Moderators({required this.username, required this.profilePicture});

  factory Moderators.fromJson(Map<String, dynamic> json) {
    return Moderators(
      username: json['username'],
      profilePicture: json['profilePicture'],
    );
  }
}

class Rule {
  final String text;
  final String appliesTo;
  //final String id;

  Rule({required this.text, required this.appliesTo});

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      text: json['text'],
      appliesTo: json['appliesTo'],
      //id: json['_id'],
    );
  }
}