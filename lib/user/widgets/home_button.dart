import 'package:flutter/material.dart';
import 'package:ptest/main/utils/is_mobile.dart';

class HomeButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const HomeButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white30, width: 2),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveManager.width(.030, .030, .030),
            ),
          ),
        ),
      ),
    );
  }
}
