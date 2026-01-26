import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('Smoke test - App inicia na tela de login', (WidgetTester tester) async {
    // É necessário envolver o MyApp em um ProviderScope para o Riverpod funcionar,
    // mesmo em testes simples.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verifica se o título do app e o botão de login estão presentes.
    // Isso garante que o app iniciou e renderizou a LoginPage corretamente.
    expect(find.text('Family Tracker'), findsOneWidget);
    expect(find.text('Entrar com Google'), findsOneWidget);
    
    // Garante que não temos resquícios do contador padrão
    expect(find.byIcon(Icons.add), findsNothing);
  });
}