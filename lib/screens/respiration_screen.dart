import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum _BreathPhase { idle, inhale, hold, exhale, done }

class RespirationScreen extends StatefulWidget {
  const RespirationScreen({super.key});

  @override
  State<RespirationScreen> createState() => _RespirationScreenState();
}

class _RespirationScreenState extends State<RespirationScreen>
    with SingleTickerProviderStateMixin {
  static const int _phaseDuration = 4;
  static const int _totalCycles = 5;

  _BreathPhase _phase = _BreathPhase.idle;
  int _countdown = _phaseDuration;
  int _currentCycle = 0;
  Timer? _timer;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _phaseDuration),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _currentCycle = 1;
      _phase = _BreathPhase.inhale;
      _countdown = _phaseDuration;
    });
    _animController.forward(from: 0);
    _runTimer();
  }

  void _reset() {
    _timer?.cancel();
    _animController.stop();
    _animController.reset();
    setState(() {
      _phase = _BreathPhase.idle;
      _countdown = _phaseDuration;
      _currentCycle = 0;
    });
  }

  void _runTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _countdown--);

      if (_countdown <= 0) {
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    _timer?.cancel();

    if (_phase == _BreathPhase.inhale) {
      setState(() {
        _phase = _BreathPhase.hold;
        _countdown = _phaseDuration;
      });
      // Mantém círculo expandido durante o hold
      _animController.stop();
      _runTimer();
    } else if (_phase == _BreathPhase.hold) {
      setState(() {
        _phase = _BreathPhase.exhale;
        _countdown = _phaseDuration;
      });
      _animController.reverse(from: 1.0);
      _runTimer();
    } else if (_phase == _BreathPhase.exhale) {
      if (_currentCycle >= _totalCycles) {
        setState(() => _phase = _BreathPhase.done);
        _animController.reset();
      } else {
        setState(() {
          _currentCycle++;
          _phase = _BreathPhase.inhale;
          _countdown = _phaseDuration;
        });
        _animController.forward(from: 0);
        _runTimer();
      }
    }
  }

  String get _phaseLabel {
    switch (_phase) {
      case _BreathPhase.inhale:
        return 'Inspire';
      case _BreathPhase.hold:
        return 'Segure';
      case _BreathPhase.exhale:
        return 'Expire';
      default:
        return '';
    }
  }

  Color get _phaseColor {
    switch (_phase) {
      case _BreathPhase.inhale:
        return AppColors.minimum;
      case _BreathPhase.hold:
        return AppColors.minimum.withOpacity(0.6);
      case _BreathPhase.exhale:
        return AppColors.minimum.withOpacity(0.35);
      default:
        return AppColors.minimum;
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
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Respiração guiada',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Indicador de ciclos
                if (_phase != _BreathPhase.idle && _phase != _BreathPhase.done)
                  Text(
                    'Ciclo $_currentCycle de $_totalCycles',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text.withOpacity(0.6),
                    ),
                  ),

                const SizedBox(height: 48),

                // Círculo animado
                if (_phase != _BreathPhase.idle && _phase != _BreathPhase.done)
                  AnimatedBuilder(
                    animation: _scaleAnim,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnim.value,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _phaseColor.withOpacity(0.15),
                            border: Border.all(color: _phaseColor, width: 3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_countdown',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: _phaseColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 32),

                // Label da fase
                if (_phase != _BreathPhase.idle && _phase != _BreathPhase.done)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      _phaseLabel,
                      key: ValueKey(_phase),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _phaseColor,
                      ),
                    ),
                  ),

                // Tela inicial
                if (_phase == _BreathPhase.idle) ...[
                  const Icon(Icons.air, size: 80, color: AppColors.minimum),
                  const SizedBox(height: 24),
                  const Text(
                    'Respiração 4-4-4',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Inspire por 4 segundos, segure por 4 e expire por 4. Repita 5 vezes para se acalmar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _PrimaryButton(label: 'Começar', onTap: _start),
                ],

                // Tela de conclusão
                if (_phase == _BreathPhase.done) ...[
                  const Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: AppColors.minimum,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Muito bem!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Você completou os 5 ciclos. Espero que esteja se sentindo melhor.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _PrimaryButton(label: 'Fazer novamente', onTap: _start),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Voltar ao início',
                      style: TextStyle(fontSize: 16, color: AppColors.minimum),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.minimum,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
