import 'dart:async';
import 'dart:convert';
import 'package:animation_sanasa/models/contas.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

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
  final TextEditingController cpfCnpjController = TextEditingController();
  List<DropdownMenuItem<String>> dropdownCodigosConsumidor = [];
  String? cod;
  bool isSearch = false;
  List<ConsumidorInfo> consumidores = [];
  bool openCadastro = true;

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
    cod = await Env.getCod();
    codController.text = cod!;
    _fetchTokenList(codController.text);
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

  List<ConsumidorInfo> _createConsumidorList(List<dynamic> dadosJson) {
    List<ConsumidorInfo> list = [];

    for (var item in dadosJson) {
      list.add(ConsumidorInfo(item['cpfCnpjVinculado'], "Interessado"));
    }
    return list;
  }

  void _updateTable(String codUpdate) {
    cod = codUpdate;
    consumidores = [];
    _fetchTokenList(cod!);
  }

  List<DataRow> createDataRows() {
    return consumidores.map(
      (consumidor) {
        return DataRow(
          cells: [
            DataCell(
              Text(
                consumidor.cpfCnpj,
              ),
            ),
            DataCell(IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Você tem certeza?'),
                      content:
                          Text('Deseja realmente excluir este consumidor?'),
                      actions: [
                        TextButton(
                          child: Text('Não'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Fecha o AlertDialog
                          },
                        ),
                        TextButton(
                          child: Text('Sim'),
                          onPressed: () async {
                            Navigator.of(context).pop(); // Fecha o AlertDialog
                            await sendPostRequestDesvincular(
                                consumidor.cpfCnpj);

                            // Remova o consumidor da lista após a chamada ser realizada com sucesso
                            setState(() {
                              consumidores.remove(consumidor);
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ))
          ],
        );
      },
    ).toList();
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro de Validação"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Feche o pop-up
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendPostRequest(String cod) async {
    // Validando o tamanho do CPF/CNPJ
    int length = cpfCnpjController.text
        .replaceAll(RegExp('[^0-9]'), '')
        .length; // Remove caracteres não numéricos e conta os dígitos

    if (length != 11 && length != 14) {
      _showErrorDialog(context,
          "O CPF ou CNPJ inserido é inválido. Certifique-se de que tenha 11 ou 14 dígitos.");
      return; // Encerra a execução da função aqui
    }

    if (length == 11 && !CPF.isValid(cpfCnpjController.text)) {
      _showErrorDialog(context, "O CPF inserido é inválido.");
      return;
    }

    if (length == 14 && !CNPJ.isValid(cpfCnpjController.text)) {
      _showErrorDialog(context, "O CNPJ inserido é inválido.");
      return;
    }
    const url =
        'https://portal-dev.sanasa.com.br/api/app/consumidores/vincularcpfcnpjconsumidor';
    meuToken = await Env.getToken();
    print(cod);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $meuToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'codigoConsumidor': cod,
        'cpfCnpjVinculado': cpfCnpjController.text,
      }),
    );

    if (response.statusCode == 200) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37),
              ),
              title: const Text(
                "Solicitação realizada com sucesso!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(ThemeColors.textColorCard),
                ),
              ),
              content: Lottie.asset('assets/animation/check.json',
                  height: 100, width: 100),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      cpfCnpjController.text = "";
                      _updateTable(cod);
                    });
                    // Feche o pop-up
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      });
    } else {
      var jsonResponse = jsonDecode(response.body);
      List<String> errorList = List<String>.from(jsonResponse['erros']);
      String errorMessage = errorList.join(', ');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37),
              ),
              title: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(ThemeColors.textColorCard),
                ),
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
      });
    }
  }

  Future<void> sendPostRequestDesvincular(String cpf) async {
    const url =
        'https://portal-dev.sanasa.com.br/api/app/consumidores/desvincularcpfcnpjconsumidor';
    meuToken = await Env.getToken();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $meuToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'codigoConsumidor': codController.text,
        'cpfCnpjVinculado': cpf,
      }),
    );

    if (response.statusCode == 200) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37),
              ),
              title: const Text(
                "Solicitação realizada com sucesso!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(ThemeColors.textColorCard),
                ),
              ),
              content: Lottie.asset('assets/animation/check.json',
                  height: 100, width: 100),
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
      });
    } else {
      var jsonResponse = jsonDecode(response.body);
      List<String> errorList = List<String>.from(jsonResponse['erros']);
      String errorMessage = errorList.join(', ');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37),
              ),
              title: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(ThemeColors.textColorCard),
                ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
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
                            ExpansionTile(
                              title: Text(
                                'Cadastrar Interessado',
                                style: TextStyle(
                                  color: Color(0xFF212529),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SizedBox(
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Digite o CPF ou CNPJ do interessado, só os numeros',
                                        style: TextStyle(
                                          color: Color(0xFF212529),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomInputField(
                                  labelText: "CPF/CNPJ",
                                  controller: cpfCnpjController,
                                  validatorNumber: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.06,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        sendPostRequest(cod!);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Cadastrar',
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
                              ],
                            ),
                            const SizedBox(height: 20),
                            consumidores.isEmpty
                                ? Center(
                                    child: Column(
                                      children: [
                                        Text(
                                            "Sem nenhum interessado neste código")
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: consumidores.isNotEmpty
                                        ? DataTable(
                                            columns: const [
                                              DataColumn(
                                                label: Text(
                                                  'CPF/CNPJ',
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  '',
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                            rows: createDataRows(),
                                          )
                                        : const Center(
                                            child: Text(
                                              "Não existe faturas atrasadas para este CPF",
                                              style:
                                                  TextStyle(color: Colors.red),
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

class CPF {
  // Validar número de CPF
  static bool isValid(String? cpf) {
    if (cpf == null) return false;

    // Obter somente os números do CPF
    var numeros = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CPF possui 11 dígitos
    if (numeros.length != 11) return false;

    // Testar se todos os dígitos do CPF são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numeros)) return false;

    // Dividir dígitos
    List<int> digitos =
        numeros.split('').map((String d) => int.parse(d)).toList();

    // Calcular o primeiro dígito verificador
    var calcDv1 = 0;
    for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
      calcDv1 += digitos[10 - i] * i;
    }
    calcDv1 %= 11;
    var dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Testar o primeiro dígito verificado
    if (digitos[9] != dv1) return false;

    // Calcular o segundo dígito verificador
    var calcDv2 = 0;
    for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
      calcDv2 += digitos[11 - i] * i;
    }
    calcDv2 %= 11;
    var dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Testar o segundo dígito verificador
    if (digitos[10] != dv2) return false;

    return true;
  }
}

class CNPJ {
  // Validar número de CNPJ
  static bool isValid(String? cnpj) {
    if (cnpj == null) return false;

    // Obter somente os números do CNPJ
    var numeros = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CNPJ possui 14 dígitos
    if (numeros.length != 14) return false;

    // Testar se todos os dígitos do CNPJ são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numeros)) return false;

    // Dividir dígitos
    List<int> digitos =
        numeros.split('').map((String d) => int.parse(d)).toList();

    // Calcular o primeiro dígito verificador
    var calcDv1 = 0;
    var j = 0;
    for (var i in Iterable<int>.generate(12, (i) => i < 4 ? 5 - i : 13 - i)) {
      calcDv1 += digitos[j++] * i;
    }
    calcDv1 %= 11;
    var dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Testar o primeiro dígito verificado
    if (digitos[12] != dv1) return false;

    // Calcular o segundo dígito verificador
    var calcDv2 = 0;
    j = 0;
    for (var i in Iterable<int>.generate(13, (i) => i < 5 ? 6 - i : 14 - i)) {
      calcDv2 += digitos[j++] * i;
    }
    calcDv2 %= 11;
    var dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Testar o segundo dígito verificador
    if (digitos[13] != dv2) return false;

    return true;
  }
}
