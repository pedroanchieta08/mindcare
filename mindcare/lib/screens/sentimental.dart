import 'package:flutter/material.dart';
import '../data/sentiment_store.dart';

typedef _OpcaoHumor = ({String emoji, String label});

const List<_OpcaoHumor> _opcoesHumor = [
  (emoji: '😡', label: 'Irritado'),
  (emoji: '☹️', label: 'Triste'),
  (emoji: '😌', label: 'Calmo'),
  (emoji: '😨', label: 'Ansioso'),
  (emoji: '😊', label: 'Feliz'),
];

const _backgroundColor = Color(0xFFDEF0F3);
const _curveColor = Color(0xFFB2DDE2);
const _circleColor = Color(0xFF0E550F);
const _buttonColor = Color(0xFF5F8B7B);
const _activeColor = Color(0xFFDDE5FF);

class SentimentalPage extends StatefulWidget {
  const SentimentalPage({super.key});

  @override
  State<SentimentalPage> createState() => _SentimentalPageState();
}

class _SentimentalPageState extends State<SentimentalPage> {
  _OpcaoHumor? _humorSelect;

  void _registrar() {
    if (_humorSelect == null) {
      _showSnackbar('Selecione um sentimento');
      return;
    }

    SentimentStore().save(DateTime.now(), _humorSelect!.emoji);
    _showSnackbar('Sentimento registrado no calendário');
  }

  void _showSnackbar(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          _CurvedBackground(height: size.height * 0.78),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BotaoVoltar(
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(height: 12),
                  _Emoji(emoji: _humorSelect?.emoji ?? ''),
                  const SizedBox(height: 10),
                  _SeletorHumor(
                    opcoes: _opcoesHumor,
                    selecionado: _humorSelect,
                    onSelecionado: (opcao) =>
                        setState(() => _humorSelect = opcao),
                  ),
                  const SizedBox(height: 4),
                  const _CampoTexto(),
                  const SizedBox(height: 16),
                  _BotaoRegistrar(onPressed: _registrar),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotaoVoltar extends StatelessWidget {
  const _BotaoVoltar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
    );
  }
}

class _CurvedBackground extends StatelessWidget {
  const _CurvedBackground({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        color: _curveColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(90),
          bottomRight: Radius.circular(90),
        ),
      ),
    );
  }
}

class _Emoji extends StatelessWidget {
  const _Emoji({required this.emoji});

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _circleColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 72)),
      ),
    );
  }
}

class _SeletorHumor extends StatelessWidget {
  const _SeletorHumor({
    required this.opcoes,
    required this.selecionado,
    required this.onSelecionado,
  });

  final List<_OpcaoHumor> opcoes;
  final _OpcaoHumor? selecionado;
  final ValueChanged<_OpcaoHumor> onSelecionado;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(72),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final opcao in opcoes)
            _ItemHumor(
              opcao: opcao,
              ativo: selecionado?.label == opcao.label,
              onTap: () => onSelecionado(opcao),
            ),
        ],
      ),
    );
  }
}

class _ItemHumor extends StatelessWidget {
  const _ItemHumor({
    required this.opcao,
    required this.ativo,
    required this.onTap,
  });

  final _OpcaoHumor opcao;
  final bool ativo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: ativo ? _activeColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(opcao.emoji, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(height: 8),
          Text(
            opcao.label,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  const _CampoTexto();

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 6,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Fale um pouco sobre o que sente...',
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _BotaoRegistrar extends StatelessWidget {
  const _BotaoRegistrar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Registrar Sentimento',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
