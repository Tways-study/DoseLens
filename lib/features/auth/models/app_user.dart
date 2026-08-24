enum UserRole { patient, caregiver }

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final UserRole role;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    required this.role,
    required this.createdAt,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      role: (data['role'] as String?) == 'caregiver'
          ? UserRole.caregiver
          : UserRole.patient,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'role': role.name,
        'createdAt': createdAt,
      };
}
