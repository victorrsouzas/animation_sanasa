import 'package:animation_sanasa/models/service.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:flutter/material.dart';

class ServiceListItem extends StatelessWidget {
  const ServiceListItem({
    super.key,
    required this.service,
    required this.onSelectService,
  });

  final Service service;
  final void Function() onSelectService;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onSelectService,
      splashColor: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/sanasahome.png', // Caminho do ícone do Service
                  width: screenWidth * 0.25, // 15% da largura da tela
                  height: screenWidth * 0.25, // 15% da largura da tela
                  // Cor do ícone (ajuste conforme necessário)
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black, // Cor do título (ajuste conforme necessário)
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        service
                            .description, // Supondo que Service tem um campo 'description'
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors
                              .grey, // Cor da descrição (ajuste conforme necessário)
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15.0),
                const Icon(Icons.arrow_forward_ios,
                    size: 18.0, color: Colors.grey), // Ícone de seta
              ],
            ),
          ),
          SizedBox(
            width: screenWidth * 0.9, // Ajuste a largura conforme necessário
            child: const Divider(
              color: Color(ThemeColors.borderInput), // Cor da linha
              thickness: 1.0, // Espessura da linha
            ),
          ),
        ],
      ),
    );
  }
}
