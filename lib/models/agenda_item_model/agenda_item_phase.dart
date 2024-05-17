enum AgendaItemPhase {
  idle(0),
  active(1),
  activeButFinished(2),
  over(3);

  const AgendaItemPhase(this.value);
  final int value;

  factory AgendaItemPhase.fromValue(int value) {
    var type = idle;

    for (var element in AgendaItemPhase.values) {
      if (value == element.value) {
        type = element;
      }
    }

    return type;
  }

  bool get activeOrOver => this != idle;
}