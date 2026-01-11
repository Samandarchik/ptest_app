import 'package:flutter/material.dart';
import 'package:ptest/main/core/di/di.dart';
import 'package:ptest/main/utils/go_router.dart';
import 'package:ptest/main/utils/is_mobile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInit();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ResponsiveManager.init(constraints, context);

        return MaterialApp.router(
          routerConfig: router,

          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveManager.pick(
                  mobile: 16,
                  tablet: 20,
                  desktop: 30,
                ),
              ),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveManager.pick(
                  mobile: 16,
                  tablet: 20,
                  desktop: 30,
                ),
              ),
            ),
            scaffoldBackgroundColor: ResponsiveManager.pick(
              mobile: Colors.grey,
              tablet: Colors.red,
              desktop: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
