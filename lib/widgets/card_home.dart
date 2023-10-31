import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardHome extends StatelessWidget {
  const CardHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomCard(),
        SizedBox(height: 10),
        CustomCard(),
      ],
    );
  }
}

class CustomCard extends StatefulWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: ThemeColors.shimmerGradient,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            width: 1,
            color: ThemeColors.primary,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Agosto/23',
                            style: TextStyle(
                              color: Color(ThemeColors.textColorCard),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Vencimento 05/09',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Color(ThemeColors.textColorCard),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: ThemeColors.primary,
                            size: 14,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'R\$ 120,00',
                            style: TextStyle(
                              color: Color(ThemeColors.textColorCard),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                color: ThemeColors.primary,
                                size: 14,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Copiar\nCódigo',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Color(ThemeColors.textColorCard),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              Icon(
                                Icons.file_copy,
                                color: ThemeColors.primary,
                                size: 14,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Gerar\nPDF',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Color(ThemeColors.textColorCard),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
