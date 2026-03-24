class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? address;
  final int? companyId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.companyId,
  });

  bool get isBuyer => role.toLowerCase() == 'buyer';
  bool get isSupplier => role.toLowerCase() == 'supplier';
}
