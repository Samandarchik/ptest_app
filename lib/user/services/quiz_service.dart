import 'package:dio/dio.dart';
import 'package:ptest/main/core/constants/urls.dart';
import 'package:ptest/main/core/di/di.dart';
import 'package:ptest/user/models/quiz_model.dart';

class QuizService {
  Dio dio = sl<Dio>();

  Future<List<QuizModel>> getQuiz(String id) async {
    try {
      final response = await dio.get(AppUrls.tickets + id);

      if (response.statusCode == 200) {
        final List data = response.data['tickets'];

        return data.map((e) => QuizModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
    }

    return [];
  }
}
