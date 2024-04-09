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
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Community &&
        other.name == name &&
        other.members == members &&
        other.description == description &&
        other.icon == icon &&
        other.isJoined == isJoined;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        members.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        isJoined.hashCode;
  }

  @override
  String toString() {
    return 'Community{name: $name, members: $members, description: $description, icon: $icon, isJoined: $isJoined}';
  }

}
