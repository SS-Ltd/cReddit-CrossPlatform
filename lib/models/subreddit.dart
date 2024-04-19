class Subreddit {
  final String name;
  final String icon;
  final String? banner;
  final int members;
  final List<String> rules;
  final List<String> moderators;
  final String? description;

  Subreddit({
    required this.name,
    required this.icon,
    required this.banner,
    required this.members,
    required this.rules,
    required this.moderators,
    required this.description,
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
      moderators: List<String>.from(json['moderators']),
      description: json['description'] ?? '',
    );
  }
}
