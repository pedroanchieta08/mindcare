import '../models/profissional_model.dart';

class ProfissionalRepository {
  static final List<ProfissionalModel> _profissionais = [
    ProfissionalModel(
      name: 'Dr. João Silva',
      email: 'profissional@email.com',
      password: '123456',
    ),
  ];

  static List<ProfissionalModel> get profissionais => _profissionais;

  static bool emailExists(String email) {
    return _profissionais.any(
      (profissional) => profissional.email.toLowerCase() == email.toLowerCase(),
    );
  }

  static void register(ProfissionalModel profissional) {
    _profissionais.add(profissional);
  }

  static ProfissionalModel? login(String email, String password) {
    try {
      return _profissionais.firstWhere(
        (profissional) =>
            profissional.email.toLowerCase() == email.toLowerCase() &&
            profissional.password == password,
      );
    } catch (_) {
      return null;
    }
  }
}
