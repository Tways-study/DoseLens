import 'package:cloud_firestore/cloud_firestore.dart';

enum CaregiverLinkStatus { pending, active, revoked }

class CaregiverLink {
  final String id;
  final String patientId;
  final String caregiverId;
  final String caregiverEmail;
  final CaregiverLinkStatus status;
  final DateTime createdAt;

  const CaregiverLink({
    required this.id,
    required this.patientId,
    required this.caregiverId,
    required this.caregiverEmail,
    required this.status,
    required this.createdAt,
  });

  factory CaregiverLink.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CaregiverLink(
      id: doc.id,
      patientId: data['patientId'] as String? ?? '',
      caregiverId: data['caregiverId'] as String? ?? '',
      caregiverEmail: data['caregiverEmail'] as String? ?? '',
      status: _statusFrom(data['status'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'patientId': patientId,
        'caregiverId': caregiverId,
        'caregiverEmail': caregiverEmail,
        'status': status.name,
        'createdAt': FieldValue.serverTimestamp(),
      };

  static CaregiverLinkStatus _statusFrom(String? s) {
    switch (s) {
      case 'active': return CaregiverLinkStatus.active;
      case 'revoked': return CaregiverLinkStatus.revoked;
      default: return CaregiverLinkStatus.pending;
    }
  }
}
