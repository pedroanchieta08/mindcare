import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class ProfessionalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveProfessional({
    required String uid,
    required String nome,
    required String email,
  }) async {
    await _firestore.collection('profissional').doc(uid).set({
      'uid': uid,
      'nome': nome,
      'email': email,
      'role': 'professional',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<AppUser?> getProfessionalById(String uid) async {
    final doc = await _firestore.collection('profissional').doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;

    return AppUser(
      uid: data['uid'] ?? uid,
      name: data['nome'] ?? '',
      email: data['email'] ?? '',
      role: 'professional',
    );
  }

  Future<List<AppUser>> getAllProfessionals() async {
    final snapshot = await _firestore.collection('profissional').get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return AppUser(
            uid: data['uid'] ?? '',
            name: data['nome'] ?? '',
            email: data['email'] ?? '',
            role: 'professional',
          );
        })
        .toList();
  }

  Future<void> updateProfessional({
    required String uid,
    required String nome,
    required String email,
  }) async {
    await _firestore.collection('profissional').doc(uid).update({
      'nome': nome,
      'email': email,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProfessional(String uid) async {
    await _firestore.collection('profissional').doc(uid).delete();
  }
}
