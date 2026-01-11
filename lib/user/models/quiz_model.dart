class QuizModel {
  final String id;
  final String topicId;
  final Map<String, dynamic> question;
  final String imgUrl;
  final int bilet;
  List<OptionModel> options;

  QuizModel({
    required this.id,
    required this.topicId,
    required this.question,
    required this.imgUrl,
    required this.bilet,
    required this.options,
  });
  //fromJson
  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      topicId: json['topic_id'],
      question: json['question'] ?? {},
      imgUrl: json['img_url'] ?? '',
      bilet: json['bilet'] ?? 0,
      options: (json['options'] as List<dynamic>)
          .map((item) => OptionModel.fromJson(item))
          .toList(),
    );
  }
}

class OptionModel {
  String id;
  String key;
  Map<String, dynamic> text;
  bool isAnswer;

  OptionModel({
    required this.id,
    required this.key,
    required this.text,
    required this.isAnswer,
  });
  //fromJson
  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      key: json['key'],
      text: json['text'],
      isAnswer: json['is_answer'],
    );
  }
}
