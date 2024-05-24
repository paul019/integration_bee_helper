enum IntegralType {
  regular('regular'),
  spare('spare');

  const IntegralType(this.id);
  final String id;

  factory IntegralType.fromString(String id) {
    var level = regular;

    for (var element in IntegralType.values) {
      if (id == element.id) {
        level = element;
      }
    }

    return level;
  }
}
