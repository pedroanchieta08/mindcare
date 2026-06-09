import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SentimentEntry {
  final String emoji;
  final String label;
  final String text;
  final DateTime date;

  SentimentEntry({
    required this.emoji,
    required this.label,
    required this.text,
    required this.date,
  });

  factory SentimentEntry.fromMap(Map<String, dynamic> map) {
    return SentimentEntry(
      emoji: map['emoji'] ?? '',
      label: map['label'] ?? '',
      text: map['text'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}

class SentimentStore {
  SentimentStore._internal();

  static final SentimentStore _instance = SentimentStore._internal();

  factory SentimentStore() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _key(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  String get _uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Usuário não está logado.');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore.collection('users').doc(_uid).collection('sentiments');
  }

  Future<void> save({
    required DateTime date,
    required String emoji,
    required String label,
    required String text,
    bool sharedWithProfessional = false,
    String? sharedProfessionalUid,
    String? patientName,
  }) async {
    final data = {
      'emoji': emoji,
      'label': label,
      'text': text,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'sharedWithProfessional': sharedWithProfessional,
    };

    if (sharedProfessionalUid != null) {
      data['sharedProfessionalUid'] = sharedProfessionalUid;
    }

    if (patientName != null) {
      data['patientName'] = patientName;
    }

    await _collection.add(data);
  }

  Stream<List<SentimentEntry>> watchEntries() {
    return _collection.orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SentimentEntry.fromMap(doc.data()))
          .toList();
    });
  }

  Future<SentimentEntry?> get(DateTime date) async {
    final doc = await _collection.doc(_key(date)).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return SentimentEntry.fromMap(doc.data()!);
  }
}
