import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_entry.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_stage.dart';

class TournamentTreeModel {
  final String? rawText;
  final List<TournamentTreeStage> stages;

  TournamentTreeModel({this.rawText, required this.stages});

  static TournamentTreeModel decode(String text) {
    final List<TournamentTreeStage> stages = [];

    for (final String stage in text.split('\n')) {
      final List<TournamentTreeEntry> entries = [];

      for (final String entry in stage.split(';')) {
        final List<String> parts = entry.split(',');

        entries.add(TournamentTreeEntry(
          title: parts[0],
          subtitle: parts.length >= 2 ? parts[1] : '',
          flex: parts.length >= 3 ? int.parse(parts[2]) : 1,
        ));
      }

      stages.add(TournamentTreeStage(entries: entries));
    }

    return TournamentTreeModel(rawText: text, stages: stages);
  }

  String encode() {
    return rawText ?? stages.map((stage) {
      return stage.entries.map((entry) {
        return '${entry.title},${entry.subtitle},${entry.flex}';
      }).join(';');
    }).join('\n');
  }
}
