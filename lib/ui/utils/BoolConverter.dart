class BoolConverter{
  static String boolToWord(bool val) {
    if(val) {
      return 'Yes';
    } else {
      return 'No';
    }
  }

  static String boolToWordUpperCase(bool val) {
    if(val) {
      return 'YES';
    } else {
      return 'NO';
    }
  }
}