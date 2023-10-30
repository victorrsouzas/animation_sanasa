import 'dart:convert';
import 'dart:io';
import 'package:animation_sanasa/data/service_data.dart';
import 'package:animation_sanasa/models/contas.dart';
import 'package:animation_sanasa/models/service.dart';
import 'package:animation_sanasa/screens/financeiro.dart';
import 'package:animation_sanasa/screens/gerenciamento.dart';
import 'package:animation_sanasa/screens/login.dart';
import 'package:animation_sanasa/screens/selected_code.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:animation_sanasa/widgets/custom_menubar.dart';
import 'package:animation_sanasa/widgets/main_drawer.dart';
import 'package:animation_sanasa/widgets/services_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Map<String, dynamic>? meuTokenDecodificado;
  String? username;
  String? cod;
  List<Conta> contas = [];
  List<Conta> filteredContas = [];
  String? meuToken;

  @override
  void initState() {
    super.initState();
    _fetchDecodedToken();
    // Chame a função para mostrar o pop-up quando a tela inicial for carregada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoPopup();
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  Future<void> _fetchDecodedToken() async {
    meuTokenDecodificado = await Env.getDecodedToken();
    username = meuTokenDecodificado?["name"];
    cod = await Env.getCod();
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
    } else {
      print('Erro ao buscar os dados: ${response.statusCode}');
    }

    filteredContas =
        contas.where((conta) => conta.codigoConsumidor == cod).toList();
    setState(() {}); // Isso fará com que a UI reconstrua se necessário
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Função para mostrar o pop-up com informações
  void _showInfoPopup() {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Informações Importantes"),
            content: const Text(
              "Este é um pop-up com informações importantes para o usuário. Você pode personalizá-lo de acordo com suas necessidades.",
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Informações Importantes"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(37),
            ),
            content: const Text(
              "Este é um pop-up com informações importantes para o usuário. Você pode personalizá-lo de acordo com suas necessidades.",
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
  }

  void _setScreen(String identifier) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop(); // Fecha o Drawer
      if (identifier == 'Gerenciamento') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const GerenciamentoContasScreen(),
          ),
        );
      } else if (identifier == 'Sair') {
        setState(() {
          logout(context);
        });
      }
    });
  }

  void _selectCategory(BuildContext context, Service service) {
    Widget? nextPage;

    switch (service.title) {
      case 'Financeiro':
        nextPage = const FinanceiroScreen();
        break;
      default:
        _showInfoPopup();
        return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => nextPage!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(ThemeColors.background),
      appBar: const CustomMenuBar(),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
        drawerHome: true,
      ),
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
                        'Bem vindo(a)',
                        style: TextStyle(
                          color: Color(0xFF212529),
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        username ?? "Usuário(a)",
                        style: const TextStyle(
                          color: Color(0xFF868E96),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 0.05,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SelectedCode(),
                          ),
                        ); // Navegar de volta à tela anterior
                      },
                      icon: const Icon(
                        Icons.reply_all_outlined,
                        color: Color(0xFF868E96),
                        size: 16,
                      ),
                      label: Text(
                        "$cod - ${filteredContas[0].tipoLogradouro} ${filteredContas[0].logradouro}, ${filteredContas[0].numero} - ${filteredContas[0].bairro}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF868E96),
                          fontSize: 14,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
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
                      height: screenHeight * 0.35,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(ThemeColors.borderInput),
                            ),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Column(
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
                                  'Como podemos te ajudar hoje?',
                                  style: TextStyle(
                                    color: Color(0xFF343A40),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 0.09,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: screenWidth *
                                0.8, // Ajuste a largura conforme necessário
                            child: const Divider(
                              color: Color(
                                  ThemeColors.borderInput), // Cor da linha
                              thickness: 1.0, // Espessura da linha
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AnimatedBuilder(
                            animation: _animationController,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              itemCount: availableServices.length,
                              itemBuilder: (ctx, index) {
                                final service = availableServices[index];
                                return ServiceListItem(
                                  service: service,
                                  onSelectService: () {
                                    _selectCategory(context, service);
                                  },
                                );
                              },
                            ),
                            builder: (context, child) => SlideTransition(
                              position: Tween(
                                begin: const Offset(0, 0.3),
                                end: const Offset(0, 0.0),
                              ).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: child,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
