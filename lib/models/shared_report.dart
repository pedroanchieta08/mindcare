import 'package:cloud_firestore/cloud_firestore.dart';

class SharedReport {
  final String id;
  final String userId;
  final String patientName;
  final Map<String, int> counts;
  final int totalEntries;
  final DateTime sharedAt;

  SharedReport({
    required this.id,
    required this.userId,
    required this.patientName,
    required this.counts,
    required this.totalEntries,
    required this.sharedAt,
  });

  factory SharedReport.fromMap(String id, Map<String, dynamic> map) {
    final rawCounts = Map<String, dynamic>.from(map['counts'] ?? {});
    final counts = <String, int>{};
    rawCounts.forEach((key, value) {
      if (value is int) {
        counts[key.toString()] = value;
      } else if (value is num) {
        counts[key.toString()] = value.toInt();
      }
    });

    return SharedReport(
      id: id,
      userId: map['userId']?.toString() ?? '',
      patientName: map['patientName']?.toString() ?? '',
      counts: counts,
      totalEntries: map['totalEntries'] is int
          ? map['totalEntries'] as int
          : counts.values.fold(0, (sum, value) => sum + value),
      sharedAt: map['sharedAt'] is DateTime
          ? map['sharedAt'] as DateTime
          : (map['sharedAt'] is Timestamp
              ? (map['sharedAt'] as Timestamp).toDate()
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'patientName': patientName,
      'counts': counts,
      'totalEntries': totalEntries,
      'sharedAt': sharedAt,
    };
  }
}
