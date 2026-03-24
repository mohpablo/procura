import 'package:flutter/material.dart';

class RecentActivity {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String type; // 'order', 'notification', 'rating', etc.
  final IconData icon;
  final Color color;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.type,
    required this.icon,
    required this.color,
  });
}
