import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_entry.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_stage.dart';

class TournamentTreeModel {
  final String? rawText;
  final List<TournamentTreeStage> stages;

  TournamentTreeModel({this.rawText, required this.stages});

  static TournamentTreeModel decode(String text) {
    final List<TournamentTreeStage> stages = [];

    for (final String stage in text.split('\n')) {
      if (stage.trim().isEmpty) {
        continue;
      }

      final List<TournamentTreeEntry> entries = [];

      for (final String entry in stage.split(';')) {
        final List<String> parts = entry.split(',');

        entries.add(TournamentTreeEntry(
          title: parts.isNotEmpty ? parts[0].trim() : '',
          subtitle: parts.length >= 2 ? parts[1].trim() : '',
          flex: parts.length >= 3 ? int.parse(parts[2]) : 1,
        ));
      }

      stages.add(TournamentTreeStage(entries: entries));
    }

    return TournamentTreeModel(rawText: text, stages: stages);
  }

  String encode() {
    return rawText ??
        stages.map((stage) {
          return stage.entries.map((entry) {
            return '${entry.title},${entry.subtitle},${entry.flex}';
          }).join(';');
        }).join('\n');
  }

  bool get isEmpty => stages.isEmpty;
  int get numOfStages => stages.length;

  TournamentTreeEntry? getEntryAtCoordinate(int i, int j) {
    if (numOfStages > i) {
      final stage = stages[i];
      if (stage.entries.length > j) {
        return stage.entries[j];
      }
    }

    return null;
  }

  TournamentTreeModel replaceEntryAtCoordinate(int i, int j, TournamentTreeEntry entry) {
    final List<TournamentTreeStage> newStages = List.of(stages);

    if (i < numOfStages) {
      final stage = stages[i];
      if (j < stage.entries.length) {
        final List<TournamentTreeEntry> newEntries = List.of(stage.entries);
        newEntries[j] = entry;
        newStages[i] = TournamentTreeStage(entries: newEntries);
      }
    }

    return TournamentTreeModel(stages: newStages);
  }
}
