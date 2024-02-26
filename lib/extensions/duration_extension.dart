extension DurationExtension on Duration {
  String timerString() {
    String negativeSign = isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60).abs());
    if (inHours > 0) {
      return "$negativeSign${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
