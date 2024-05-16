class TimerModel {
  final DateTime? timerStopsAt;
  final Duration? pausedTimerDuration;

  TimerModel({
    this.timerStopsAt,
    this.pausedTimerDuration,
  });

  factory TimerModel.fromJson(Map<String, dynamic> json) => TimerModel(
        timerStopsAt: json['timerStopsAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['timerStopsAt'])
            : null,
        pausedTimerDuration: json['pausedTimerDuration'] != null
            ? Duration(seconds: json['pausedTimerDuration'])
            : null,
      );

  static TimerModel get empty => TimerModel(
        timerStopsAt: null,
        pausedTimerDuration: null,
      );

  Map<String, dynamic> toJson() => {
        'timerStopsAt': timerStopsAt?.millisecondsSinceEpoch,
        'pausedTimerDuration': pausedTimerDuration?.inSeconds,
      };

  TimerModel pause() {
    Duration pausedTimerDuration =
        timerStopsAt?.difference(DateTime.now()) ?? Duration.zero;

    if (pausedTimerDuration.isNegative) {
      pausedTimerDuration = Duration.zero;
    }

    return TimerModel(
      timerStopsAt: null,
      pausedTimerDuration: pausedTimerDuration,
    );
  }

  TimerModel resume() {
    return TimerModel(
      timerStopsAt: DateTime.now().add(pausedTimerDuration ?? Duration.zero),
      pausedTimerDuration: null,
    );
  }

  bool get paused => pausedTimerDuration != null;

  bool? get timeUp => timerStopsAt?.isBefore(DateTime.now());
}
