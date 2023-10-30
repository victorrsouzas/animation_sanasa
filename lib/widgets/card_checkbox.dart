import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:flutter/material.dart';

class CardCheckbox extends StatelessWidget {
  final int index;
  final String title;
  final String description;
  final String subdescription;
  final int selectedCardIndex;
  final Function(int) onCardSelected;

  const CardCheckbox({
    Key? key,
    required this.index,
    required this.title,
    required this.description,
    required this.subdescription,
    required this.selectedCardIndex,
    required this.onCardSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onCardSelected(index);
      },
      child: Card(
        elevation: 0.0,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        shadowColor: ThemeColors.primary,
        surfaceTintColor: ThemeColors.primary,
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: selectedCardIndex,
              onChanged: (int? value) {
                onCardSelected(index);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Adicione espaçamento aqui
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: ThemeColors.primary),
                    ),
                    const SizedBox(height: 20), // Espaçamento entre os textos
                    Text(
                      "$description\n\n Tarifa Social: $subdescription",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(ThemeColors.textColorCard),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
