import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ThemeColors.primary
                  .withOpacity(0.55), // Usando a cor 100 do seu tema
              ThemeColors.primary
                  .withOpacity(0.9), // Usando a cor 200 do seu tema
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Image.asset(
                'assets/image/sanasa_branco.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
      elevation: 0, // Remove a elevação
      backgroundColor: Colors.transparent, // Defina como transparente
    );
  }
}
