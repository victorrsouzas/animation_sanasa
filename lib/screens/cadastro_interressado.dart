import 'dart:convert';

import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class CadastrarInteresseScreen extends StatefulWidget {
  const CadastrarInteresseScreen({super.key});

  @override
  State<CadastrarInteresseScreen> createState() =>
      _CadastrarInteresseScreenState();
}

class _CadastrarInteresseScreenState extends State<CadastrarInteresseScreen> {
  final TextEditingController codController = TextEditingController();
  String? meuToken;
  Map<String, dynamic>? meuTokenDecodificado;
  String? cpf;

  Future<void> sendPostRequest() async {
    const url =
        'https://portal-dev.sanasa.com.br/api/app/consumidores/vincularcpfcnpjconsumidor';
    meuToken = await Env.getToken();
    meuTokenDecodificado = await Env.getDecodedToken();
    cpf = meuTokenDecodificado?["cpf"];

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
                  'Cadastrar Interesse',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Digite o CPF ou CNPJ do interessado',
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
                        labelText: "CPF/CNPJ",
                        controller: codController,
                        validatorNumber: true,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              sendPostRequest();
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
