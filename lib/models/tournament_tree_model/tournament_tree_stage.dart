import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_entry.dart';

class TournamentTreeStage {
  final List<TournamentTreeEntry> entries;

  TournamentTreeStage({required this.entries});

  int get totalFlex => entries.map((e) => e.flex).reduce((a, b) => a + b);
}
