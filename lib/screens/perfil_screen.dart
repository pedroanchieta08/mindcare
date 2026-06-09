import 'dart:typed_data'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:mindcare/constants/app_colors.dart';
import 'package:mindcare/widgets/bottombar.dart';
import 'package:mindcare/services/auth_service.dart'; 
import '../models/app_user.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AppUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  late Future<DocumentSnapshot> _dadosUsuarioFuture;

  Uint8List? _webImageBytes; 
  bool _isEditingDadosPessoais = false;
  bool _isEditingSeguranca = false;
  bool _isEditingPrivacidade = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    
    _dadosUsuarioFuture = _buscarDadosDoUsuario();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<DocumentSnapshot> _buscarDadosDoUsuario() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();
  }

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _pickImageLocal() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 50,
    );
    
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _webImageBytes = imageBytes; 
      });
    }
  }

  void _updateLocalData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });

      setState(() {
        _dadosUsuarioFuture = _buscarDadosDoUsuario();
        _isEditingDadosPessoais = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Suas Alterações foram Salvas!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao salvar as Alterações: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blueGrey),
            tooltip: 'Sair',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _dadosUsuarioFuture, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Erro ao carregar dados do Firebase."));
          }

          Map<String, dynamic> dadosDoBanco = snapshot.data!.data() as Map<String, dynamic>;

          if (!_isEditingDadosPessoais) {
            _nameController.text = dadosDoBanco['name'] ?? '';
            _emailController.text = dadosDoBanco['email'] ?? '';
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImageLocal, 
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.minimum,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipOval(
                          child: _webImageBytes != null
                              ? Image.memory(
                                  _webImageBytes!, 
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.smallDetail,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  dadosDoBanco['name'] ?? 'Sem Nome',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.minimum,
                  ),
                ),
                Text(
                  dadosDoBanco['email'] ?? 'Sem E-mail',
                  style: const TextStyle(color: AppColors.text),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatCard('30', 'Registros'),
                    _buildStatCard('4', 'Semanas'),
                    _buildStatCard('7.4', 'Média'),
                  ],
                ),
                const SizedBox(height: 16),
                _buildExpandableSection(
                  title: 'MINHA CONTA',
                  items: [
                    _buildExpandableTile(
                      icon: Icons.person_outline,
                      title: 'Dados pessoais',
                      subtitle: 'Nome, email, foto',
                      isExpanded: _isEditingDadosPessoais,
                      onToggle: () => setState(() => _isEditingDadosPessoais = !_isEditingDadosPessoais),
                      expandedContent: _buildDadosPessoaisForm(),
                    ),
                    _buildExpandableTile(
                      icon: Icons.lock_outline,
                      title: 'Segurança',
                      subtitle: 'Senha e autenticação',
                      isExpanded: _isEditingSeguranca,
                      onToggle: () => setState(() => _isEditingSeguranca = !_isEditingSeguranca),
                      expandedContent: _buildSegurancaForm(dadosDoBanco['email'] ?? widget.user.email),
                    ),
                    _buildExpandableTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacidade',
                      subtitle: 'Controle de dados',
                      isExpanded: _isEditingPrivacidade,
                      onToggle: () => setState(() => _isEditingPrivacidade = !_isEditingPrivacidade),
                      expandedContent: const Text('Configurações de privacidade disponíveis em breve.'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.largeDetail, 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Column(children: items),
        ],
      ),
    );
  }

  Widget _buildExpandableTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget expandedContent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.largeDetail,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: AppColors.smallDetail),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
              color: AppColors.smallDetail,
            ),
            onTap: onToggle,
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: expandedContent,
            ),
        ],
      ),
    );
  }

  Widget _buildDadosPessoaisForm() {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[200], 
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.smallDetail, width: 1.5),
              ),
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Nome :',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'E-mail :',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _updateLocalData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.smallDetail,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'SALVAR ALTERAÇÕES', 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegurancaForm(String emailUsuario) {
    return Column(
      children: [
        const Text(
          'Para sua segurança, enviamos um link de redefinição para o seu e-mail cadastrado. Lá você poderá criar uma nova senha.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () async {
              try {
                await AuthService().sendPasswordResetEmail(emailUsuario);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('E-mail enviado para: $emailUsuario'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao enviar e-mail: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.smallDetail,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'ALTERAR MINHA SENHA',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}