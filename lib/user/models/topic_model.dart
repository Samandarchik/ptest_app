class TopicModel {
  final String id;
  final Map<String, String> name;

  TopicModel({required this.id, required this.name});

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
