import 'dart:convert';

import 'package:animation_sanasa/models/debitos.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FaturaAtrasadaScreen extends StatefulWidget {
  const FaturaAtrasadaScreen({super.key});

  @override
  State<FaturaAtrasadaScreen> createState() => _FaturaAtrasadaScreenState();
}

class _FaturaAtrasadaScreenState extends State<FaturaAtrasadaScreen> {
  final TextEditingController cpfController = TextEditingController();
  bool isSearch = false;
  String? meuToken;
  List<Debito> debitos = [];
  List<Debito> filteredDebitos = [];

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  @override
  void dispose() {
    cpfController;
    isSearch;
    super.dispose();
  }

  Future<void> _fetchToken() async {
    meuToken = await Env.getToken();
    const url = 'https://portal-dev.sanasa.com.br/api/app/debitos';

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
      debitos = dadosJson.map((json) => Debito.fromJson(json)).toList();
      print(data);
    } else {
      print('Erro ao buscar os dados: ${response.statusCode}');
    }
    setState(() {}); // Isso fará com que a UI reconstrua se necessário
  }

  List<DataRow> createDataRows(List<Debito> debitos) {
    return debitos.map((debito) {
      return DataRow(
        cells: [
          const DataCell(
            Icon(
              Icons
                  .cancel, // Coloque sua lógica para definir o ícone baseado no status aqui
              color: Colors.red,
            ),
          ),
          DataCell(
            Text(
              "${months[debito.mes]} ${debito.ano}", // Converter número do mês para nome do mês
              textAlign: TextAlign.start,
            ),
          ),
          const DataCell(
            Icon(Icons.qr_code),
          ),
          const DataCell(
            Icon(Icons.file_copy),
          )
        ],
      );
    }).toList();
  }

  void searchDebito() {
    String cpfInput = cpfController.text.trim();
    setState(() {
      filteredDebitos =
          debitos.where((debito) => debito.cpfCnpj == cpfInput).toList();
      isSearch = true;
    });
  }

  final months = [
    '',
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(ThemeColors.background),
      appBar: const CustomMenuBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Faturas Atrasadas",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ThemeColors.primary,
                  fontSize: 24,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomInputField(
                labelText: 'CPF/CNPJ',
                controller: cpfController,
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: screenWidth * 0.8,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searchDebito();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(37),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Consultar',
                      style: TextStyle(
                        color: Color(0xFFF1F5F4),
                        fontSize: 18,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if (isSearch)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: filteredDebitos.isNotEmpty
                      ? DataTable(
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Status',
                                textAlign: TextAlign.start,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Mês',
                                textAlign: TextAlign.start,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Copiar\nCódigo',
                                textAlign: TextAlign.start,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Baixar\nPDF',
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                          rows: createDataRows(debitos),
                        )
                      : const Center(
                          child: Text(
                            "Não existe faturas atrasadas para este CPF",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
