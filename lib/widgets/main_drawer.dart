import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer(
      {super.key, required this.onSelectScreen, required this.drawerHome});

  final void Function(
    String identifier,
  ) onSelectScreen;
  final bool drawerHome;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Map<String, dynamic>? meuTokenDecodificado;
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchDecodedToken();
  }

  Future<void> _fetchDecodedToken() async {
    meuTokenDecodificado = await Env.getDecodedToken();
    username = meuTokenDecodificado?["name"];
    setState(() {}); // Isso fará com que a UI reconstrua se necessário
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidth * 0.7,
      backgroundColor: const Color(ThemeColors.background),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 28,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  username ?? "Usuário(a)",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.drawerHome,
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  onTap: () {
                    widget.onSelectScreen('Gerenciamento');
                  },
                  title: Row(
                    children: [
                      const Icon(
                        Icons.manage_accounts,
                        size: 16,
                        color: ThemeColors.primary,
                      ),
                      const SizedBox(
                          width: 16.0), // Espaçamento entre o ícone e o texto
                      Text(
                        'Gerenciamento de contas',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: ThemeColors.primary,
                              fontSize: 14,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenWidth, // Ajuste a largura conforme necessário
                  child: const Divider(
                    color: Color(0xFFE5E5E5), // Cor da linha
                    thickness: 1.0, // Espessura da linha
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: screenWidth, // Ajuste a largura conforme necessário
            child: const Divider(
              color: Color(0xFFE5E5E5), // Cor da linha
              thickness: 1.0, // Espessura da linha
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            onTap: () {
              widget.onSelectScreen('Sair');
            },
            title: Row(
              children: [
                const Icon(
                  Icons.logout,
                  size: 16,
                  color: ThemeColors.primary,
                ),
                const SizedBox(
                    width: 16.0), // Espaçamento entre o ícone e o texto
                Text(
                  'Sair',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: ThemeColors.primary,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
