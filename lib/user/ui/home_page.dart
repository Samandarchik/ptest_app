import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ptest/main/utils/gap.dart';
import 'package:ptest/main/utils/is_mobile.dart';
import 'package:ptest/user/widgets/home_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {"title": "🏢 Mavzu bo‘yicha testlar", "route": "/topic"},
      {"title": "✔ Imtihon topshirish"},
      {"title": "⚙ Sozlamali testlar"},
      {"title": "⛽ Biletlar bo'yicha testlar"},
      {"title": "📃 Barcha testlar javoblari"},
      {"title": "🛸 Marafon rejimi"},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        ResponsiveManager.init(constraints, context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              ResponsiveManager.pick(
                mobile: "Mobile",
                tablet: "Tablet",
                desktop: "Desktop",
              ),
            ),
          ),
          body: Center(
            child: Container(
              width: ResponsiveManager.width(.75, .75, .60),
              height: ResponsiveManager.height(.80, .80, .80),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white30, width: 2),
              ),
              child: Padding(
                padding: EdgeInsets.all(ResponsiveManager.width(.02, .02, .02)),
                child: ListView(
                  children: [
                    15.gap,
                    Center(
                      child: Text(
                        "🚀 Prava olish endi biz bilan oson!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveManager.width(.030, .030, .030),
                        ),
                      ),
                    ),
                    Divider(),
                    15.gap,
                    ...List.generate(
                      menuItems.length,
                      (i) => Column(
                        children: [
                          HomeButton(
                            title: menuItems[i]["title"],
                            onTap: menuItems[i]["route"] != null
                                ? () => context.push(menuItems[i]["route"])
                                : null,
                          ),
                          15.gap,
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.telegram,
                            color: Colors.grey,
                            size: ResponsiveManager.screenWidth * .043,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
