import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final int? relatedId;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    type,
    isRead,
    createdAt,
    relatedId,
  ];
}
