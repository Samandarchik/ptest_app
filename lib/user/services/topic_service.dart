import 'package:dio/dio.dart';
import 'package:ptest/main/core/constants/urls.dart';
import 'package:ptest/main/core/di/di.dart';
import 'package:ptest/user/models/topic_model.dart';

class TopicService {
  Dio dio = sl<Dio>();

  Future<List<TopicModel>> getTopics() async {
    try {
      final response = await dio.get(AppUrls.topics);

      if (response.statusCode == 200) {
        final List data = response.data;

        return data
            .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print(e);
    }

    return [];
  }
}
