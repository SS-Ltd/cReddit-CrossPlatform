class Subreddit {
  final String name;
  final String icon;
  final String banner;
  final int members;
  final List<String> rules;
  final List<String> moderators;

  Subreddit({
    required this.name,
    required this.icon,
    required this.banner,
    required this.members,
    required this.rules,
    required this.moderators,
  });

  factory Subreddit.fromJson(Map<String, dynamic> json) {
    return Subreddit(
      name: json['name'],
      icon: json['icon'],
      banner: json['banner'],
      members: json['members'],
      rules: List<String>.from(json['rules']),
      moderators: List<String>.from(json['moderators']),
    );
  }
}
