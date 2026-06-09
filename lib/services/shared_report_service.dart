import 'package:cloud_firestore/cloud_firestore.dart';

class SharedReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> shareReport({
    required String professionalUid,
    required String userId,
    required String patientName,
    required Map<String, int> counts,
    required int totalEntries,
    required DateTime sharedAt,
  }) async {
    await _firestore
        .collection('profissional')
        .doc(professionalUid)
        .collection('sharedReports')
        .add({
          'userId': userId,
          'patientName': patientName,
          'counts': counts,
          'totalEntries': totalEntries,
          'sharedAt': Timestamp.fromDate(sharedAt),
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchSharedReports(
    String professionalUid,
  ) {
    return _firestore
        .collection('profissional')
        .doc(professionalUid)
        .collection('sharedReports')
        .orderBy('sharedAt', descending: true)
        .snapshots();
  }
}
