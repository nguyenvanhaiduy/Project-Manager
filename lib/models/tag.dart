class Tag {
  String id;
  String owner;
  String title;
  List<String> tagNames;

  Tag(
      {required this.id,
      required this.owner,
      required this.title,
      required this.tagNames});

  factory Tag.fromMap({required Map<String, dynamic> data}) {
    return Tag(
      id: data['id'],
      owner: data['owner'],
      title: data['title'],
      tagNames: List<String>.from(
        data['tagNames'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner': owner,
      'title': title,
      'tagNames': tagNames,
    };
  }
}
