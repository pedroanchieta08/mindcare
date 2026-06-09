import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/professional_service.dart';
import '../models/app_user.dart';
import 'home_screen.dart';
import 'relatorios_profissional.dart';
import '../models/profissional_model.dart';

enum _AccountType { user, professional }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final ProfessionalService _professionalService = ProfessionalService();
  _AccountType _accountType = _AccountType.user;

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    try {
      final credential = await _authService.register(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao criar usuário.')));
        return;
      }

      final role = _accountType == _AccountType.professional
          ? 'professional'
          : 'user';

      final appUser = AppUser(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        role: role,
      );

      try {
        if (role == 'professional') {
          await _professionalService.saveProfessional(
            uid: firebaseUser.uid,
            nome: name,
            email: email,
          );
        } else {
          await _userService.saveUser(appUser);
        }
      } catch (firestoreError) {
        await firebaseUser.delete();
        throw Exception(
          'Erro ao salvar dados do usuário: ${firestoreError.toString()}',
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      final isProfessional = role == 'professional';

      if (isProfessional) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RelatoriosProfissional(
              profissional: ProfissionalModel(
                name: appUser.name,
                email: appUser.email,
                password: '',
              ),
            ),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: appUser)),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (authError) {
      String message = 'Erro ao cadastrar.';

      if (authError.code == 'email-already-in-use') {
        message = 'Este e-mail já está em uso.';
      } else if (authError.code == 'invalid-email') {
        message = 'E-mail inválido.';
      } else if (authError.code == 'weak-password') {
        message = 'A senha deve conter pelo menos 6 caracteres.';
      } else {
        message = 'Erro de autenticação: ${authError.code}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
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
                'Escolha o tipo da conta para direcionar o login.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.text),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<_AccountType>(
                    value: _accountType,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: _AccountType.user,
                        child: Text('Sou usuário'),
                      ),
                      DropdownMenuItem(
                        value: _AccountType.professional,
                        child: Text('Sou profissional'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _accountType = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
