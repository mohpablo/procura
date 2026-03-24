import 'package:saas_app/core/utils/json_utils.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.companyId,
    super.address,
    super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: JsonUtils.parseInt(json['id']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'buyer',
      companyId: JsonUtils.parseInt(json['company_id']),
      address: json['address']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "company_id": companyId,
      "address": address,
      "phone": phone,
    };
  }
}
