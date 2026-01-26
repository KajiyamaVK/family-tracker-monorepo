import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/features/authentication/login_page.dart';
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
  });

  Widget createSubject() {
    return ProviderScope(
      overrides: [
        // AQUI ESTÁ A MÁGICA: Substituímos a implementação real pelo Mock
        googleSignInProvider.overrideWithValue(mockGoogleSignIn),
      ],
      child: const MaterialApp(
        home: LoginPage(),
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

  testWidgets('Deve exibir perfil do usuário após login com sucesso', (tester) async {
    // Configura o mock para retornar sucesso no login
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);

    await tester.pumpWidget(createSubject());

    // Clica no botão de login
    await tester.tap(find.text('Entrar com Google'));
    
    // Aguarda as microtasks (Futures) completarem e reconstrói a UI
    await tester.pump(); 

    // Verifica se a UI mudou para o perfil
    expect(find.text('Teste Kajiyama'), findsOneWidget);
    expect(find.text('teste@kajiyama.com'), findsOneWidget);
    expect(find.text('Sair'), findsOneWidget);
    
    // O botão de login deve ter sumido
    expect(find.text('Entrar com Google'), findsNothing);
  });

  testWidgets('Deve voltar para tela de login após logout', (tester) async {
    // Cenário: Usuário já logado
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);
    when(() => mockGoogleSignIn.disconnect()).thenAnswer((_) async => mockAccount);

    await tester.pumpWidget(createSubject());

    // Realiza Login
    await tester.tap(find.text('Entrar com Google'));
    await tester.pump();

    // Confirma que está logado
    expect(find.text('Sair'), findsOneWidget);

    // Clica em Sair
    await tester.tap(find.text('Sair'));
    await tester.pump();

    // Verifica se voltou para tela inicial
    expect(find.text('Entrar com Google'), findsOneWidget);
    expect(find.text('Teste Kajiyama'), findsNothing);
  });

  testWidgets('Não deve mudar estado se o login for cancelado (retornar null)', (tester) async {
    // Configura o mock para retornar null (cancelamento do popup)
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

    await tester.pumpWidget(createSubject());

    await tester.tap(find.text('Entrar com Google'));
    await tester.pump();

    // Deve permanecer na tela de login
    expect(find.text('Entrar com Google'), findsOneWidget);
    expect(find.text('Sair'), findsNothing);
  });
}