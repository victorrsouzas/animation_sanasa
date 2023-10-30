import 'package:animation_sanasa/screens/login.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/widgets/custom_appbar.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(ThemeColors.background),
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                icon: const Icon(
                  Icons.arrow_back,
                  color: ThemeColors.primary,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  ); // Navegar de volta à tela anterior
                },
              ),
            ],
          ),
          const Text(
            "Recuperação de\nSenha",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF428BCA),
              fontSize: 24,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Para recuperar a sua senha, informe seu\nendereço de e-mail que nós enviaremos um\nlink para a alteração da senha',
            style: TextStyle(
              color: Color(0xFF428BCA),
              fontSize: 16,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          CustomInputField(labelText: "E-mail", controller: emailController),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: screenWidth * 0.8,
            height: screenHeight * 0.07,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirmação de Envio"),
                      content: Text(
                          "Deseja enviar para ${emailController.text} a solicitação de recuperação de senha?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Fechar o AlertDialog
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Coloque aqui a lógica para enviar a solicitação de recuperação de senha
                            // Fechar o AlertDialog
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            ); // Navegar de volta à tela anterior
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColors.primary,
                          ),
                          child: const Text("Enviar"),
                        ),
                      ],
                    );
                  },
                );
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
                  'Enviar',
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
        ],
      ),
    );
  }
}
