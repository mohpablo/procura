import 'package:saas_app/features/profile/domain/entities/user_profile.dart';
import 'package:saas_app/core/utils/json_utils.dart';

class UserProfileModel {
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

  UserProfileModel({
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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: JsonUtils.parseInt(json['id']),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'buyer',
      profilePicture: json['profile_picture'] as String?,
      bio: json['bio'] as String?,
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      zipCode: json['zip_code'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'profile_picture': profilePicture,
    'bio': bio,
    'address': address,
    'city': city,
    'country': country,
    'zip_code': zipCode,
    'created_at': createdAt.toIso8601String(),
  };

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      profilePicture: profilePicture,
      bio: bio,
      address: address,
      city: city,
      country: country,
      zipCode: zipCode,
      createdAt: createdAt,
    );
  }
}
