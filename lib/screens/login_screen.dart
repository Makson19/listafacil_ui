import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final senhaFocus = FocusNode();

  bool senhaVisivel = false;
  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    senhaFocus.dispose();
    super.dispose();
  }

  String? validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    if (email.isEmpty) return 'Informe seu e-mail';
    final formato = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!formato.hasMatch(email)) return 'Digite um e-mail válido';
    return null;
  }

  String? validarSenha(String? valor) {
    final senha = valor ?? '';
    if (senha.isEmpty) return 'Informe sua senha';
    if (senha.length < 4) return 'Use pelo menos 4 caracteres';
    return null;
  }

  Future<void> entrar() async {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    // Simulação da chamada de autenticação.
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute<void>(builder: (_) => const ListaComprasScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE7F4EF), Color(0xFFF7FAF8)]
          )
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                gradient: AppTheme.gradientePrimario,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaria
                                        .withValues(alpha: 0.28),
                                    blurRadius: 26,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.shopping_basket_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'ListaFácil',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                              color: AppTheme.texto,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Organize suas compras e saiba exatamente\nquanto vai gastar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.5,
                              height: 1.45,
                              color: AppTheme.textoSecundario,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 32,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Entre para acessar sua lista de compras.',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: AppTheme.textoSecundario,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  autofillHints: const [AutofillHints.email],
                                  validator: validarEmail,
                                  enabled: !carregando,
                                  decoration: const InputDecoration(
                                    labelText: 'E-mail',
                                    hintText: 'voce@exemplo.com',
                                    prefixIcon: Icon(Icons.mail_outline_rounded),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: senhaController,
                                  focusNode: senhaFocus,
                                  obscureText: !senhaVisivel,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  validator: validarSenha,
                                  enabled: !carregando,
                                  onFieldSubmitted: (_) => entrar(),
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    hintText: 'Mínimo de 4 caracteres',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                    ),
                                    suffixIcon: IconButton(
                                      tooltip: senhaVisivel
                                          ? 'Ocultar senha'
                                          : 'Mostrar senha',
                                      onPressed: () => setState(
                                        () => senhaVisivel = !senhaVisivel,
                                      ),
                                      icon: Icon(
                                        senhaVisivel
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 54,
                                  child: FilledButton(
                                    onPressed: carregando ? null : entrar,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: carregando
                                          ? const Row(
                                              key: ValueKey('carregando'),
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.4,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text('Entrando...'),
                                              ],
                                            )
                                          : const Row(
                                              key: ValueKey('entrar'),
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Entrar'),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.arrow_forward_rounded,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
