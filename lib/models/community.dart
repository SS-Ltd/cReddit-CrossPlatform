class Community {
  final String name;
  final int members;
  final String? description;
  final String icon;
  final bool isJoined;
  Community({
    required this.name,
    required this.members,
    required this.description,
    required this.icon,
    required this.isJoined,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      name: json['name'],
      icon: json['icon'],
      members: json['members'],
      description: json['description'],
      isJoined: json['isJoined'],
    );
  }
}
