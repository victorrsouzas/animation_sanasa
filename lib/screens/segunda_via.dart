import 'dart:convert';

import 'package:animation_sanasa/models/contas.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SegundaViaScreen extends StatefulWidget {
  const SegundaViaScreen({super.key});

  @override
  State<SegundaViaScreen> createState() => _SegundaViaScreenState();
}

class _SegundaViaScreenState extends State<SegundaViaScreen> {
  final TextEditingController codController = TextEditingController();
  final TextEditingController refController = TextEditingController();
  String? meuToken;
  List<Conta> contas = [];
  String? cod;
  List<DropdownMenuItem<String>> dropdownCodigosConsumidor = [];
  String? selectedCodigoConsumidor;
  String? selectedMesAno;

  Future<void> _showSuccessDialog(BuildContext context) async {
    String referencia = refController.text;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(37),
          ),
          title: const Text(
            "Segunda via gerada com sucesso!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(ThemeColors.textColorCard),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: ThemeColors.primary,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            referencia,
                            style: const TextStyle(
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                Icons.qr_code_scanner,
                                color: ThemeColors.primary,
                                size: 14,
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Copiar\nCódigo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(ThemeColors.textColorCard),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              const Icon(
                                Icons.picture_as_pdf,
                                color: ThemeColors.primary,
                                size: 14,
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Gerar\nPDF',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(ThemeColors.textColorCard),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
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
              const SizedBox(
                height: 20,
              ),
              Lottie.asset('assets/animation/check.json',
                  height: 100, width: 100),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Prefere receber sua fatura mensal por e-mail ao cadastrar-se na opção de fatura digital?",
                  style: TextStyle(
                    color: Color(ThemeColors.textColorCard),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Clique aqui para acessar a Fatura Digital",
                  style: TextStyle(
                    color: Color(ThemeColors.textColorCard),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Feche o pop-up
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _abrirUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchToken();
    dropdownMeses = generateMonthYearItems();
  }

  Future<void> _fetchToken() async {
    meuToken = await Env.getToken();
    cod = await Env.getCod();
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
      dropdownCodigosConsumidor = contas
          .map((conta) => DropdownMenuItem(
                value: conta.codigoConsumidor.toString(),
                child: Text(
                    "${conta.codigoConsumidor.toString()} - ${conta.tipoLogradouro.toString()} ${conta.logradouro.toString()}, ${conta.numero.toString()}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14)),
              ))
          .toList();
    } else {
      print('Erro ao buscar os dados: ${response.statusCode}');
    }
    setState(() {}); // Isso fará com que a UI reconstrua se necessário
  }

  List<DropdownMenuItem<String>> dropdownMeses = [];

  List<DropdownMenuItem<String>> generateMonthYearItems() {
    final List<String> months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    // Iniciar em Março de 2023
    int startYear = 2023;
    int startMonth = 3;

    final DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    final List<DropdownMenuItem<String>> items = [];

    while ((startYear < currentYear) ||
        (startYear == currentYear && startMonth <= currentMonth)) {
      final String month = months[startMonth - 1];

      items.add(DropdownMenuItem(
        value: '$month/$startYear',
        child: Text('$month/$startYear'),
      ));

      if (startMonth == 12) {
        startMonth = 1;
        startYear++;
      } else {
        startMonth++;
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(ThemeColors.background),
      appBar: const CustomMenuBar(),
      body: contas.isEmpty
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Center(
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
                          '2ª Via de Fatura e Código de Barras',
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
                                height: 40,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                  width: screenWidth * 0.9,
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Selecione o código de consumidor',
                                      style: TextStyle(
                                        color: Color(0xFF212529),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        height: 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomInputField(
                                labelText: 'Código de referência do Consumidor',
                                controller: codController,
                                isDropbutton:
                                    true, // Isso indica que é um dropdown
                                dropdownItems:
                                    dropdownCodigosConsumidor, // Passa os itens do dropdown
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                  width: screenWidth * 0.9,
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Selecione o mês de referência',
                                      style: TextStyle(
                                        color: Color(0xFF212529),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        height: 0.05,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomInputField(
                                labelText: 'Referência',
                                controller: refController,
                                isDropbutton:
                                    true, // Isso indica que é um dropdown
                                dropdownItems:
                                    dropdownMeses, // Passa os itens do dropdown
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Container(
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.25,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text:
                                                  'ATENÇÃO: Faturas anteriores a Março/2023 podem ser emitidas ',
                                              style: TextStyle(
                                                color: ThemeColors.primary,
                                                fontSize: 16,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'aqui',
                                              style: const TextStyle(
                                                color: ThemeColors.primary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  _abrirUrl(
                                                      'https://www.sanasa.com.br/servico/segundaviaV2.aspx?f=A');
                                                },
                                            ),
                                            const TextSpan(
                                              text:
                                                  '.\n\nTelefones 0800.7721195 regiões com DDD 019 ou (19) 3735.5000 demais regiões, ou em uma das nossas ',
                                              style: TextStyle(
                                                color: Color(
                                                    ThemeColors.textColorCard),
                                                fontSize: 16,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'agências de atendimento.',
                                              style: const TextStyle(
                                                color: ThemeColors.primary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  _abrirUrl(
                                                      'https://www.sanasa.com.br/servico/agencias.aspx?f=A');
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.06,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (codController.text.isNotEmpty &&
                                        refController.text.isNotEmpty) {
                                      _showSuccessDialog(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Solicitar 2ªVia',
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
            ),
    );
  }
}
