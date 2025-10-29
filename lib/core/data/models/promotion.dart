class Promotion {
  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    this.tags = const <String>[],
  });

  final String id;
  final String title;
  final String description;
  final List<String> tags;

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'tags': tags,
      };
}
