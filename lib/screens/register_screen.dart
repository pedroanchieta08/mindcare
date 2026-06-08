import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/user_repository.dart';
import '../models/user_model.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    if (UserRepository.emailExists(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este e-mail já está cadastrado.')),
      );
      return;
    }

    UserRepository.register(
      UserModel(name: name, email: email, password: password),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(
                Icons.person_add_alt_1,
                size: 82,
                color: AppColors.smallDetail,
              ),
              const SizedBox(height: 18),
              const Text(
                'Criar conta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cadastre-se direto no código, sem banco de dados.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.text),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _nameController,
                label: 'Nome',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
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
              ElevatedButton(
                onPressed: _register,
                child: const Text('CADASTRAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
