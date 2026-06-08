import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/user_repository.dart';
import '../models/user_model.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'relatorios_profissional.dart';
import '../data/profissional_repository.dart';
import '../models/profissional_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    final UserModel? user = UserRepository.login(email, password);
    final ProfissionalModel? profissional = ProfissionalRepository.login(
      email,
      password,
    );

    if (user == null && profissional == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha inválidos.')),
      );
      return;
    }

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } else if (profissional != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RelatoriosProfissional(profissional: profissional),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/imagens/logo.png', width: 250, height: 250),
              const SizedBox(height: 24),
              const Text(
                'MindCare',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Entre para cuidar melhor da sua rotina.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.text),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _emailController,
                label: 'E-mail',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _login, child: const Text('ENTRAR')),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  'Criar uma conta',
                  style: TextStyle(color: AppColors.smallDetail),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
