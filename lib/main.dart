import 'package:animation_sanasa/screens/splash_screen.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  //Obrigatoriedade para que o APP só funcione no modo retrato
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) => runApp(const ProviderScope(child: App())));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: sanasaTheme,
      home: const SplashScreen(),
    );
  }
}
