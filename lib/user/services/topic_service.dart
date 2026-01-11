import 'package:dio/dio.dart';
import 'package:ptest/main/core/constants/urls.dart';
import 'package:ptest/main/core/di/di.dart';
import 'package:ptest/user/models/topic_model.dart';

class TopicService {
  Dio dio = sl<Dio>();

  Future<List<TopicModel>?> getTopics() async {
    try {
      final response = await dio.get(
        AppUrls.topics,
        queryParameters: {'limit': 50},
        options: Options(
          sendTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((e) => TopicModel.fromJson(e))
              .toList();
        }
      }
      return null;
    } on DioException catch (e) {
      print('DioException: ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        print('Timeout error');
      } else if (e.type == DioExceptionType.connectionError) {
        print('Connection error - Server ishlamayapti yoki internet yo\'q');
      }
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }
}
