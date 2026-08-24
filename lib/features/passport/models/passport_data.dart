/// Model representing clinical health passport summary data
class PassportData {
  final String patientName;
  final double adherenceRate;
  final List<Map<String, dynamic>> activeMedications;
  final List<Map<String, dynamic>> adherenceHistory;
  final DateTime generatedAt;

  const PassportData({
    required this.patientName,
    required this.adherenceRate,
    required this.activeMedications,
    required this.adherenceHistory,
    required this.generatedAt,
  });

  int get adherencePercentage => (adherenceRate * 100).round();
  bool get isGoalMet => adherencePercentage >= 80;
}
