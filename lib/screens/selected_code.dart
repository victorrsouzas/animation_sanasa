import 'dart:async';
import 'dart:convert';
import 'package:animation_sanasa/models/contas.dart';
import 'package:animation_sanasa/screens/cadastro_interressado.dart';
import 'package:animation_sanasa/screens/desvincular_interressado.dart';
import 'package:animation_sanasa/screens/home.dart';
import 'package:animation_sanasa/screens/login.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/card_checkbox.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:animation_sanasa/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectedCode extends StatefulWidget {
  const SelectedCode({super.key});

  @override
  State<SelectedCode> createState() => _SelectedCodeState();
}

class _SelectedCodeState extends State<SelectedCode> {
  int selectedCardIndex = -1;
  String? meuToken;
  List<Conta> contas = [];
  String? selectedCardTitle;
  bool noHome = false;

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    meuToken = await Env.getToken();
    const url = 'https://portal-dev.sanasa.com.br/api/app/consumidores';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $meuToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> dadosJson = data['dados'];
      contas = dadosJson.map((json) => Conta.fromJson(json)).toList();
    } else {
      print('Erro ao buscar os dados: ${response.statusCode}');
    }
    setState(() {}); // Isso fará com que a UI reconstrua se necessário
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'Sair') {
      setState(() {
        logout(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(ThemeColors.background),
      appBar: const CustomMenuBar(),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
        drawerHome: false,
      ),
      body: contas.isEmpty
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
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
                        'Selecione um endereço',
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
                    width: screenWidth *
                        0.9, // Ajuste a largura conforme necessário
                    child: const Divider(
                      color: Color(ThemeColors.borderInput), // Cor da linha
                      thickness: 1.0, // Espessura da linha
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.7,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                              shrinkWrap: true, // Adicione esta linha
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: contas.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    CardCheckbox(
                                      index: index,
                                      title:
                                          "Cód ${contas[index].codigoConsumidor}",
                                      description:
                                          " ${contas[index].tipoLogradouro} ${contas[index].logradouro}, ${contas[index].numero} - ${contas[index].bairro}",
                                      subdescription: "XXXXXXXXXXXXX",
                                      selectedCardIndex: selectedCardIndex,
                                      onCardSelected: (int newIndex) {
                                        setState(() {
                                          selectedCardIndex = newIndex;
                                          selectedCardTitle =
                                              contas[newIndex].codigoConsumidor;
                                          Env.storeCod(selectedCardTitle!);
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20.0),
                                    SizedBox(
                                      width: screenWidth *
                                          0.8, // Ajuste a largura conforme necessário
                                      child: const Divider(
                                        color: Color(ThemeColors
                                            .borderInput), // Cor da linha
                                        thickness: 1.0, // Espessura da linha
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                  ],
                                );
                              },
                            ),
                            /* Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: ThemeColors.primary,
                                  size: 14,
                                ),
                                label: const Text(
                                  "Novo Endereço",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF428BCA),
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ), */
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          const CadastrarInteresseScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_circle_outlined,
                                  color: ThemeColors.primary,
                                  size: 14,
                                ),
                                label: const Text(
                                  "Cadastrar Interesse",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF428BCA),
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          const DesvincularInteresseScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_circle_outlined,
                                  color: ThemeColors.primary,
                                  size: 14,
                                ),
                                label: const Text(
                                  "Desvincular Interesse",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF428BCA),
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.06,
                              child: ElevatedButton(
                                onPressed: selectedCardIndex != -1
                                    ? () {
                                        // Coloque seu código de navegação aqui.
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => const Home(),
                                          ),
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Avançar',
                                    style: TextStyle(
                                      color: Color(0xFFF1F5F4),
                                      fontSize: 12,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
