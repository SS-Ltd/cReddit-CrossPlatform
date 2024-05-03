class SubredditRule{
  
  final String text;
  final String appliesTo;
  final String id;

  SubredditRule({
    required this.text,
    required this.appliesTo,
    required this.id
  });

  factory SubredditRule.fromJson(Map<String, dynamic> json){
    return SubredditRule(
      text: json['text'],
      appliesTo: json['appliesTo'],
      id: json['_id']
    );
  }
}