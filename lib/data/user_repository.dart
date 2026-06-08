import '../models/user_model.dart';

class UserRepository {
  static final List<UserModel> _users = [
    UserModel(
      name: 'Usuário Teste',
      email: 'teste@email.com',
      password: '123456',
    ),
  ];

  static List<UserModel> get users => _users;

  static bool emailExists(String email) {
    return _users.any(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );
  }

  static void register(UserModel user) {
    _users.add(user);
  }

  static UserModel? login(String email, String password) {
    try {
      return _users.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.toLowerCase() &&
            user.password == password,
      );
    } catch (_) {
      return null;
    }
  }
}
