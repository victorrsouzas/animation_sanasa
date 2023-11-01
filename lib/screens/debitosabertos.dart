import 'dart:convert';

import 'package:animation_sanasa/models/contas.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultaDebitosScreen extends StatefulWidget {
  const ConsultaDebitosScreen({super.key});

  @override
  State<ConsultaDebitosScreen> createState() => _ConsultaDebitosScreenState();
}

class _ConsultaDebitosScreenState extends State<ConsultaDebitosScreen> {
  final TextEditingController codController = TextEditingController();
  String? meuToken;
  List<Conta> contas = [];
  String? cod;
  List<DropdownMenuItem<String>> dropdownCodigosConsumidor = [];
  bool isLoading = false;
  List<DebitoInfo> debitos = [];

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchToken() async {
    meuToken = await Env.getToken();
    cod = await Env.getCod();
    codController.text = cod!;
    _fetchTokenDebitos(codController.text);
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

  Future<void> _fetchTokenDebitos(String cod) async {
    meuToken = await Env.getToken();
    const url = 'https://portal-dev.sanasa.com.br/api/financeiro/debitos';

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
      debitos = _createDebitoList(dadosJson);
    } else {
      print('Erro ao buscar os dados: ${response.statusCode}');
    }
    setState(() {}); // Isso fará com que a UI reconstrua se necessário
  }

  List<DebitoInfo> _createDebitoList(List<dynamic> dadosJson) {
    List<DebitoInfo> list = [];
    for (var item in dadosJson) {
      if (item['codigoConsumidor'] == cod) {
        list.add(DebitoInfo(item['mes'], item['ano'], item['valor']));
      }
    }

    return list;
  }

  void _updateTable(String codUpdate) {
    cod = codUpdate;
    debitos = [];
    _fetchTokenDebitos(cod!);
  }

  List<DataRow> createDataRows() {
    isLoading = true;
    List<DataRow> rows = debitos.map(
      (debito) {
        return DataRow(
          cells: [
            DataCell(Text("${months[debito.mes]}/${debito.ano}")),
            DataCell(Text("R\$ ${debito.valor}")),
            DataCell(Icon(Icons.download)), // Para baixar PDF
          ],
        );
      },
    ).toList();

    isLoading = false;
    return rows;
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
                          'Consultar débitos em aberto',
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
                                dropdownItems: dropdownCodigosConsumidor,
                                onDropdownChanged: (newCod) {
                                  _updateTable(newCod);
                                }, // Passa os itens do dropdown
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              debitos.isEmpty
                                  ? Center(
                                      child: Column(
                                        children: [
                                          Text("Sem nenhum débito neste código")
                                        ],
                                      ),
                                    )
                                  : isLoading
                                      ? Center(
                                          child: CircularProgressIndicator
                                              .adaptive(),
                                        )
                                      : SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columns: const [
                                              DataColumn(
                                                label: Text(
                                                  'Referência',
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Valor',
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
                                            rows: createDataRows(),
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

class DebitoInfo {
  final int mes;
  final int ano;
  final double valor;

  DebitoInfo(this.mes, this.ano, this.valor);
}
