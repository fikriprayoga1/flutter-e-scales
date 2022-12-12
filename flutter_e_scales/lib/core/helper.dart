// This file contain extension
extension Helper on String {
  /*
   * - This extension for parse data from Electronic Scales value to formatted data
   * - This extension only accept for A12E formatted data
   */
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
