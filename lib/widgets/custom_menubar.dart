import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMenuBar({
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ThemeColors.primary, ThemeColors.primary],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/image/sanasa_branco.png',
                fit: BoxFit.contain,
                width: screenWidth * 0.35,
                height: screenHeight * 0.05,
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
