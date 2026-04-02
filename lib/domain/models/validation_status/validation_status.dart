import 'package:flutter/material.dart';

class ValidationStatus {
  static const String uploading = 'UPLOADING';
  static const String pending = 'PENDING';
  static const String approved = 'APPROVED';
  static const String denied = 'DENIED';

  // Helper to get a color for the UI
  static Color getColor(String? status) {
    switch (status) {
      case approved: return Colors.green;
      case denied: return Colors.red;
      case pending: return Colors.orange;
      default: return Colors.grey;
    }
  }
}