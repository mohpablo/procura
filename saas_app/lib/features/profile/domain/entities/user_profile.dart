class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? profilePicture;
  final String? bio;
  final String address;
  final String city;
  final String country;
  final String zipCode;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePicture,
    this.bio,
    required this.address,
    required this.city,
    required this.country,
    required this.zipCode,
    required this.createdAt,
  });
}
