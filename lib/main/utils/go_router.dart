import 'package:go_router/go_router.dart';
import 'package:ptest/user/ui/home_page.dart';
import 'package:ptest/user/ui/topic_page.dart';

final router = GoRouter(
  initialLocation: '/home',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/topic', builder: (context, state) => const TopicsPage()),
    // GoRoute(
    //   path: '/home',
    //   builder: (context, state) => const HomePage(),
    // ),
  ],
);
