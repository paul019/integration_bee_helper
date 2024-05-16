enum IntegralLevel {
  bachelor('bachelor'),
  master('master');

  static IntegralLevel standard = IntegralLevel.bachelor;

  const IntegralLevel(this.id);
  final String id;

  factory IntegralLevel.fromString(String id) {
    var level = bachelor;

    for (var element in IntegralLevel.values) {
      if (id == element.id) {
        level = element;
      }
    }

    return level;
  }
}