import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptest/user/widgets/home_button.dart';
import 'package:ptest/user/services/topic_service.dart';
import 'package:ptest/user/models/topic_model.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  late Future<List<TopicModel>?> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = TopicService().getTopics(); // API chaqiruv
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mavzu bo'yicha testlar")),
      body: FutureBuilder<List<TopicModel>?>(
        future: _topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Ma'lumotlarni yuklab bo'lmadi"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Mavzular mavjud emas"));
          }

          final topics = snapshot.data!;
          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: HomeButton(
                  title: topics[index].name["uz"] ?? "",
                  onTap: () {
                    context.push('/quiz/${topics[index].id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
