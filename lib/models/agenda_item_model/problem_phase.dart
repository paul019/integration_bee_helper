enum ProblemPhase {
  idle(0),
  showProblem(1),
  showSolution(2),
  showSolutionAndWinner(3);

  const ProblemPhase(this.value);
  final int value;

  factory ProblemPhase.fromValue(int value) {
    var type = idle;

    for (var element in ProblemPhase.values) {
      if (value == element.value) {
        type = element;
      }
    }

    return type;
  }
}