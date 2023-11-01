import 'package:animation_sanasa/screens/consulta_fatura.dart';
import 'package:animation_sanasa/screens/debitosabertos.dart';
import 'package:animation_sanasa/screens/segunda_via.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:flutter/material.dart';

class FinanceiroScreen extends StatefulWidget {
  const FinanceiroScreen({super.key});

  @override
  State<FinanceiroScreen> createState() => _FinanceiroScreenState();
}

class _FinanceiroScreenState extends State<FinanceiroScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(ThemeColors.background),
      appBar: const CustomMenuBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Financeiro',
                  style: TextStyle(
                    color: Color(0xFF212529),
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: screenWidth * 0.9, // Ajuste a largura conforme necessário
              child: const Divider(
                color: Color(ThemeColors.borderInput), // Cor da linha
                thickness: 1.0, // Espessura da linha
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  width: screenWidth * 0.9,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(ThemeColors.borderInput),
                        ),
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              ExpansionTile(
                                title: const Text(
                                  "Consultas",
                                  style: TextStyle(
                                    color: ThemeColors.primary,
                                    fontSize: 16,
                                  ),
                                ),
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.star,
                                      color: Color(ThemeColors.textColorCard),
                                    ),
                                    title: const Text(
                                      '2ª via de Fatura e Código de Barras',
                                      style: TextStyle(
                                        color: Color(ThemeColors.textColorCard),
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      // Navegue para a página 2via
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const SegundaViaScreen(),
                                      ));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.arrow_circle_right_outlined,
                                      color: Color(ThemeColors.textColorCard),
                                    ),
                                    title: const Text(
                                      'Consulta de Faturas',
                                      style: TextStyle(
                                        color: Color(ThemeColors.textColorCard),
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      // Navegue para a página teste de via
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const ConsultaFaturasScreen(),
                                      ));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.arrow_circle_right_outlined,
                                      color: Color(ThemeColors.textColorCard),
                                    ),
                                    title: const Text(
                                      'Consultar débitos em aberto',
                                      style: TextStyle(
                                        color: Color(ThemeColors.textColorCard),
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () {
                                      // Navegue para a página teste de via
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const ConsultaDebitosScreen(),
                                      ));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
