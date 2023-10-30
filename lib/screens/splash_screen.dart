import 'dart:async';
import 'package:animation_sanasa/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<LottieComposition> _composition;

  @override
  void initState() {
    super.initState();

    _composition = AssetLottie('assets/animation/sanasa_splash.json').load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/image/background.png'), // Caminho para a imagem de fundo
          fit: BoxFit.cover, // Ajuste a imagem para cobrir todo o espaço
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FutureBuilder<LottieComposition>(
            future: _composition,
            builder: (context, snapshot) {
              var composition = snapshot.data;
              if (composition != null) {
                // Quando a animação é carregada, aguarde 6.3 segundos e vá para a próxima tela
                Future.delayed(const Duration(seconds: 6, milliseconds: 400),
                    () {
                  if (mounted) {
                    // Verificar se o widget ainda está montado
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  }
                });

                return Lottie(
                  composition: composition,
                  repeat: false,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
