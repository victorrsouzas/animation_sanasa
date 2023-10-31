import 'package:animation_sanasa/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login screen initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    expect(find.text('Olá, Seja bem-vindo!'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    // Adicione mais verificações de inicialização, se necessário
  });

  testWidgets('Verifica se _checkToken é chamado ao inicializar',
      (WidgetTester tester) async {
    // Crie o widget Login
    await tester.pumpWidget(MaterialApp(home: Login()));

    // Agora, _checkToken deve ter sido chamado automaticamente
    // Você pode verificar seus efeitos observando a interface do usuário ou o estado do widget
  });
}
