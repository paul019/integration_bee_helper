class TournamentTreeEntry {
  final String title;
  final String subtitle;
  final int flex;

  TournamentTreeEntry({
    required this.title,
    this.subtitle = '',
    this.flex = 1,
  });

  bool get isEmpty => title.isEmpty && subtitle.isEmpty;
}