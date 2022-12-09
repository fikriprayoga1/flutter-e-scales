extension Helper on String {
  String ekanKg() {
    try {
      final String result = substring(2, 9);
      final double numberValue = double.parse(result);
      return '$numberValue Kg';
    } catch (e) {
      return 'String format must be wnxxxx.xxkg';
    }
  }
}
