import 'package:animation_sanasa/screens/reset_password.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';

class CustomLogin extends StatefulWidget {
  const CustomLogin({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<CustomLogin> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  void dispose() {
    usuarioController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        CustomInputField(labelText: "Usuário", controller: usuarioController),
        const SizedBox(height: 15),
        CustomInputField(
            labelText: "Senha", controller: senhaController, isPassword: true),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ResetPassword(),
              ),
            );
          },
          child: const Text(
            'Esqueci minha senha',
            style: TextStyle(
              color: Color(0xFFA0A0A0),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: screenWidth * 0.8,
          height: screenHeight * 0.07,
          child: ElevatedButton(
            onPressed: () {
              /* Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SelectedCode(),
                ),
              ); */
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
                'Entrar',
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
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120, // Ajuste a largura conforme necessário
              child: Divider(
                color: Color(0xFFE5E5E5), // Cor da linha
                thickness: 1.0, // Espessura da linha
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'ou',
                style: TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontSize: 14,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              width: 120, // Ajuste a largura conforme necessário
              child: Divider(
                color: Color(0xFFE5E5E5), // Cor da linha
                thickness: 1.0, // Espessura da linha
              ),
            ),
          ],
        ), // Espaçamento adicional
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: screenWidth * 0.8,
          height: screenHeight * 0.07,
          child: ElevatedButton(
            onPressed: () {
              // Ação para "Entrar com GOV.br"
              // Implemente a lógica desejada aqui
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.primary[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Entrar com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Lato',
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    'gov.br',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
