import 'dart:async';
import 'dart:convert';
import 'package:animation_sanasa/models/contas.dart';
import 'package:animation_sanasa/screens/cadastro_interressado.dart';
import 'package:animation_sanasa/screens/desvincular_interressado.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GerenciamentoContasScreen extends StatefulWidget {
  const GerenciamentoContasScreen({super.key});

  @override
  State<GerenciamentoContasScreen> createState() =>
      _GerenciamentoContasScreenState();
}

class _GerenciamentoContasScreenState extends State<GerenciamentoContasScreen> {
  int selectedCardIndex = -1;
  String? meuToken;
  List<Conta> contas = [];
  final TextEditingController codController = TextEditingController();
  List<DropdownMenuItem<String>> dropdownCodigosConsumidor = [];
  String? cod;
  bool isSearch = false;
  List<ConsumidorInfo> consumidores = [];

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

  List<ConsumidorInfo> _createConsumidorList(List<dynamic> dadosJson) {
    Set<String> uniqueCpfs = Set();
    List<ConsumidorInfo> list = [];

    for (var item in dadosJson) {
      if (!uniqueCpfs.contains(item['cpfCnpj'])) {
        list.add(ConsumidorInfo(item['cpfCnpj'], "Titular"));
        uniqueCpfs.add(item['cpfCnpj']);
      }
      list.add(ConsumidorInfo(item['cpfCnpjVinculado'], "Interessado"));
    }
    return list;
  }

  Future<void> _fetchTokenList(String cod) async {
    meuToken = await Env.getToken();
    final url =
        'https://portal-dev.sanasa.com.br/api/app/consumidores/$cod/consumidoresvinculados';

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
      consumidores = _createConsumidorList(dadosJson);
      isSearch = true;
    } else {
      print('Erro ao buscar os dados: ${response.statusCode}');
    }
    setState(() {}); // Isso fará com que a UI reconstrua se necessário
  }

  List<DataRow> createDataRows() {
    return consumidores.map((consumidor) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              maskCPF(consumidor.cpfCnpj),
            ),
          ),
          DataCell(Text(consumidor.status))
        ],
      );
    }).toList();
  }

  String maskCPF(String cpf) {
    // Verifica se o CPF tem pelo menos 11 dígitos (formato padrão do CPF)
    if (cpf.length == 11) {
      // Mantém os três primeiros e os dois últimos dígitos, e substitui os dígitos do meio por '*'
      return '${cpf.substring(0, 3)}***${cpf.substring(8)}';
    }
    return cpf; // Se não estiver no formato padrão, retorna o CPF original
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
                        'Gerenciamento de Contas',
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
                          children: [
                            const SizedBox(
                              height: 20,
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
                            SizedBox(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.06,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    cod = codController.text;
                                    _fetchTokenList(cod!);
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
                            if (isSearch)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: consumidores.isNotEmpty
                                    ? DataTable(
                                        columns: const [
                                          DataColumn(
                                            label: Text(
                                              'CPF',
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Tipo',
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ],
                                        rows: createDataRows(),
                                      )
                                    : const Center(
                                        child: Text(
                                          "Não existe faturas atrasadas para este CPF",
                                          style: TextStyle(color: Colors.red),
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

class ConsumidorInfo {
  final String cpfCnpj;
  final String status;
  ConsumidorInfo(this.cpfCnpj, this.status);
}
