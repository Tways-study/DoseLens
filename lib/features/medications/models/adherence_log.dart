import 'package:cloud_firestore/cloud_firestore.dart';

enum AdherenceStatus { taken, missed, skipped, pending }

class AdherenceLog {
  final String id;
  final String medicationId;
  final String medicationName;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final AdherenceStatus status;
  final String? notes;

  const AdherenceLog({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
    this.notes,
  });

  factory AdherenceLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdherenceLog(
      id: doc.id,
      medicationId: data['medicationId'] as String? ?? '',
      medicationName: data['medicationName'] as String? ?? '',
      scheduledTime: (data['scheduledTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      takenTime: (data['takenTime'] as Timestamp?)?.toDate(),
      status: _statusFromString(data['status'] as String?),
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'medicationId': medicationId,
        'medicationName': medicationName,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'takenTime': takenTime != null ? Timestamp.fromDate(takenTime!) : null,
        'status': status.name,
        'notes': notes,
        'createdAt': FieldValue.serverTimestamp(),
      };

  static AdherenceStatus _statusFromString(String? s) {
    switch (s) {
      case 'taken': return AdherenceStatus.taken;
      case 'missed': return AdherenceStatus.missed;
      case 'skipped': return AdherenceStatus.skipped;
      default: return AdherenceStatus.pending;
    }
  }
}
