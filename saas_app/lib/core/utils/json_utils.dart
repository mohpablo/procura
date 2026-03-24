class JsonUtils {
  /// Safely parse a dynamic value to double
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      // Handle empty string or just whitespace
      if (value.trim().isEmpty) return 0.0;
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// Safely parse a dynamic value to int
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) {
      // Handle empty string or just whitespace
      if (value.trim().isEmpty) return 0;
      // Some APIs return "10.0" for an int, so try double parse first if int fails
      return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
    }
    return 0;
  }
}
