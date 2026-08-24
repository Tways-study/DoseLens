import 'package:cloud_firestore/cloud_firestore.dart';

enum MedicationFrequency { onceDaity, twiceDaily, threeTimesDaily, weekly, asNeeded }

class Medication {
  final String id;
  final String name;
  final String? genericName;
  final String dosage;
  final MedicationFrequency frequency;
  final List<String> times; // e.g. ["08:00", "20:00"]
  final String? instructions;
  final String? imageUrl;
  final DateTime startDate;
  final DateTime? endDate;
  final bool active;

  const Medication({
    required this.id,
    required this.name,
    this.genericName,
    required this.dosage,
    required this.frequency,
    required this.times,
    this.instructions,
    this.imageUrl,
    required this.startDate,
    this.endDate,
    this.active = true,
  });

  factory Medication.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Medication(
      id: doc.id,
      name: data['name'] as String? ?? '',
      genericName: data['genericName'] as String?,
      dosage: data['dosage'] as String? ?? '',
      frequency: _frequencyFromString(data['frequency'] as String?),
      times: List<String>.from(data['times'] as List? ?? ['08:00']),
      instructions: data['instructions'] as String?,
      imageUrl: data['imageUrl'] as String?,
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      active: data['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'genericName': genericName,
        'dosage': dosage,
        'frequency': frequency.name,
        'times': times,
        'instructions': instructions,
        'imageUrl': imageUrl,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
        'active': active,
        'updatedAt': FieldValue.serverTimestamp(),
      };

  static MedicationFrequency _frequencyFromString(String? s) {
    switch (s) {
      case 'twiceDaily': return MedicationFrequency.twiceDaily;
      case 'threeTimesDaily': return MedicationFrequency.threeTimesDaily;
      case 'weekly': return MedicationFrequency.weekly;
      case 'asNeeded': return MedicationFrequency.asNeeded;
      default: return MedicationFrequency.onceDaity;
    }
  }

  String get frequencyLabel {
    switch (frequency) {
      case MedicationFrequency.onceDaity: return 'Once daily';
      case MedicationFrequency.twiceDaily: return 'Twice daily';
      case MedicationFrequency.threeTimesDaily: return '3× daily';
      case MedicationFrequency.weekly: return 'Weekly';
      case MedicationFrequency.asNeeded: return 'As needed';
    }
  }

  Medication copyWith({
    String? name,
    String? genericName,
    String? dosage,
    MedicationFrequency? frequency,
    List<String>? times,
    String? instructions,
    String? imageUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? active,
  }) {
    return Medication(
      id: id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      active: active ?? this.active,
    );
  }
}
