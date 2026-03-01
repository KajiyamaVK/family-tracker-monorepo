import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neriya/features/authentication/auth_providers.dart'; // <--- Import corrigido
import 'package:neriya/router.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

void main() {
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockAccount;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockAccount = MockGoogleSignInAccount();

    // Configura o comportamento padrão do mock da conta
    when(() => mockAccount.email).thenReturn('teste@kajiyama.com');
    when(() => mockAccount.displayName).thenReturn('Teste Kajiyama');
    when(() => mockAccount.photoUrl).thenReturn(null);
    when(() => mockAccount.id).thenReturn('12345');
  });

  Widget createSubject() {
    // Agora precisamos montar o app com o Router para testar a navegação real
    return ProviderScope(
      overrides: [
        googleSignInProvider.overrideWithValue(mockGoogleSignIn),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(routerProvider);
          return MaterialApp.router(
            routerConfig: router,
          );
        },
      ),
    );
  }

  testWidgets('Deve exibir tela de login inicialmente', (tester) async {
    await tester.pumpWidget(createSubject());

    // Verifica elementos da tela de login
    expect(find.text('Family Tracker'), findsOneWidget);
    expect(find.text('Entrar com Google'), findsOneWidget);
    expect(find.text('Sair'), findsNothing);
  });

  testWidgets('Deve redirecionar para Home e exibir perfil após login com sucesso', (tester) async {
    // Configura o mock para retornar sucesso no login
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);

    await tester.pumpWidget(createSubject());

    // Clica no botão de login
    await tester.tap(find.text('Entrar com Google'));

    // Aguarda as microtasks e a animação de navegação do Router
    await tester.pumpAndSettle();

    // AGORA SIM: Verifica se estamos na HomePage vendo o perfil
    // Nota: A HomePage exibe "Bem-vindo," e o nome do usuário
    expect(find.text('Bem-vindo,'), findsOneWidget);
    expect(find.text('Teste Kajiyama'), findsOneWidget);
    expect(find.text('teste@kajiyama.com'), findsOneWidget);
    
    // O botão de login (da tela anterior) deve ter sumido
    expect(find.text('Entrar com Google'), findsNothing);
  });

  testWidgets('Deve voltar para tela de login após logout na Home', (tester) async {
    // Cenário: Login realizado com sucesso
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);
    when(() => mockGoogleSignIn.disconnect()).thenAnswer((_) async => mockAccount);

    await tester.pumpWidget(createSubject());

    // 1. Faz Login
    await tester.tap(find.text('Entrar com Google'));
    await tester.pumpAndSettle();

    // Confirma que está na Home
    expect(find.text('Teste Kajiyama'), findsOneWidget);

    // 2. Clica no botão de Sair (logout) na AppBar da Home
    await tester.tap(find.byIcon(Icons.logout));
    
    // Aguarda animação de navegação de volta
    await tester.pumpAndSettle();

    // 3. Verifica se voltou para tela de Login
    expect(find.text('Entrar com Google'), findsOneWidget);
    expect(find.text('Teste Kajiyama'), findsNothing);
  });

  testWidgets('Não deve mudar de tela se o login for cancelado (retornar null)', (tester) async {
    // Configura o mock para retornar null (cancelamento do popup)
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

    await tester.pumpWidget(createSubject());

    await tester.tap(find.text('Entrar com Google'));
    await tester.pumpAndSettle();

    // Deve permanecer na tela de login
    expect(find.text('Entrar com Google'), findsOneWidget);
    expect(find.text('Bem-vindo,'), findsNothing);
  });
}