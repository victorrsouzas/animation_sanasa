import 'package:animation_sanasa/screens/login.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/widgets/custom_input_field.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RequestCall extends StatefulWidget {
  const RequestCall({super.key});

  @override
  State<RequestCall> createState() => _RequestCallState();
}

class _RequestCallState extends State<RequestCall> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final TextEditingController fileController = TextEditingController();
  String fileName = '';

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cpfController.dispose();
    rgController.dispose();
    birthdayController.dispose();
    adressController.dispose();
    fileController.dispose();
    super.dispose();
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Impede o fechamento do AlertDialog ao tocar fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Solicitação realizada com sucesso!!",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animation/check.json',
                  height: 100, width: 100),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Navegar de volta para a tela de login após a conclusão da animação
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primary,
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    ); // Navegar de volta à tela anterior
                  },
                  icon: const Icon(Icons.arrow_back,
                      color: ThemeColors.primary, size: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                ),
              ],
            ),
            const Text(
              "Solicitar Ligação",
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
            CustomInputField(
                labelText: "Nome Completo", controller: nameController),
            const SizedBox(
              height: 15,
            ),
            CustomInputField(
                labelText: "Telefone de Contato", controller: phoneController),
            const SizedBox(
              height: 15,
            ),
            CustomInputField(labelText: "E-mail", controller: emailController),
            const SizedBox(
              height: 15,
            ),
            CustomInputField(labelText: "CPF", controller: cpfController),
            const SizedBox(
              height: 15,
            ),
            CustomInputField(labelText: "RG", controller: rgController),
            const SizedBox(
              height: 15,
            ),
            CustomInputField(
                labelText: "Data de Nascimento",
                controller: birthdayController),
            const SizedBox(
              height: 15,
            ),
            CustomInputField(
                labelText: "Endereço", controller: adressController),
            const SizedBox(
              height: 15,
            ),
            Image.asset("assets/image/mapa.png"),
            const SizedBox(
              height: 15,
            ),
            CustomInputField(
              labelText: "Anexar Documentos",
              controller: fileController,
              isInputFile: true,
              onTapCallback: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'pdf', 'doc'],
                );
                if (result != null) {
                  String selectedFileName = result.files.single.name;
                  setState(() {
                    fileName = selectedFileName;
                  });
                  fileController.text = selectedFileName;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    color: Color(0xFF89B7DE),
                    fontSize: 14,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  _showSuccessDialog(context);
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
      ),
    );
  }
}
