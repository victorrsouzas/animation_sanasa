import 'dart:convert';

import 'package:animation_sanasa/models/contas.dart';
import 'package:animation_sanasa/models/debitos.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultaFaturasScreen extends StatefulWidget {
  const ConsultaFaturasScreen({super.key});

  @override
  State<ConsultaFaturasScreen> createState() => _ConsultaFaturasScreenState();
}

class _ConsultaFaturasScreenState extends State<ConsultaFaturasScreen> {
  final TextEditingController codController = TextEditingController();
  String? meuToken;
  List<Conta> contas = [];
  String? cod;
  List<DropdownMenuItem<String>> dropdownCodigosConsumidor = [];
  List<Debito> debitos = [];
  List<Debito> filteredDebitos = [];
  bool isSearch = false;
  final TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchToken();
    _fetchTokenDebitos();
  }

  Future<void> _fetchToken() async {
    meuToken = await Env.getToken();
    cod = await Env.getCod();
    codController.text = cod!;
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

  Future<void> _fetchTokenDebitos() async {
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

  void searchDebito() {
    String cpfInput = codController.text.trim();
    setState(() {
      filteredDebitos =
          debitos.where((debito) => debito.cpfCnpj == cpfInput).toList();
    });
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
      body: debitos.isEmpty
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
                          'Consultar Faturas',
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
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: SizedBox(
                                  width: screenWidth * 0.9,
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Selecione o ano de referência',
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
                                controller: yearController,
                                isDropbutton:
                                    true, // Isso indica que é um dropdown
                                dropdownItems: const [
                                  DropdownMenuItem<String>(
                                    value: '2023',
                                    child: Text('2023'),
                                  ),
                                ], // Passa os itens do dropdown
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.06,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isSearch = true;
                                    });
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
                                      'Consultar',
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
                              const SizedBox(
                                height: 30,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: isSearch
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
                                    : null,
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
