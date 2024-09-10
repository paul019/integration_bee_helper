import 'dart:math';

import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_entry.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_model.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_stage.dart';
import 'package:integration_bee_helper/screens/settings_page/tournament_tree_entry_editor.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/settings_service/settings_service.dart';

class TournamentTreeCard extends StatefulWidget {
  final SettingsModel settings;

  const TournamentTreeCard({super.key, required this.settings});

  @override
  State<TournamentTreeCard> createState() => _TournamentTreeCardState();
}

class _TournamentTreeCardState extends State<TournamentTreeCard> {
  static const maxNumberOfStages = 4;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    MyIntl.of(context).tournamentTree,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    MyIntl.of(context).clickBoxToEdit,
                  ),
                ),
              ),
              const Divider(),
              Column(
                children: [
                  for (var i = 0; i < maxNumberOfStages; i++)
                    Row(
                      children: [
                        for (var j = 0; j < pow(2, i); j++)
                          _buildEntry(context, i, j),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TournamentTreeModel get tournamentTree {
    final initialTournamentTree = widget.settings.tournamentTree;
    final List<TournamentTreeStage> stages = [];

    for (int i = 0; i < maxNumberOfStages; i++) {
      final List<TournamentTreeEntry> entries = [];

      for (int j = 0; j < pow(2, i); j++) {
        TournamentTreeEntry? initialEntry =
            initialTournamentTree.getEntryAtCoordinate(i, j);

        entries.add(TournamentTreeEntry(
          title: initialEntry?.title ?? '',
          subtitle: initialEntry?.subtitle ?? '',
          flex: 1,
        ));
      }

      stages.add(TournamentTreeStage(entries: entries));
    }

    return TournamentTreeModel(stages: stages);
  }

  Widget _buildEntry(BuildContext context, int i, int j) {
    TournamentTreeEntry? entry = tournamentTree.getEntryAtCoordinate(i, j);
    bool isEmpty = entry == null || entry.isEmpty;

    return Flexible(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: isEmpty ? null : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            TournamentTreeEntryEditor.show(
              context: context,
              entry: entry,
              onSave: (title, subtitle) {
                final entry = TournamentTreeEntry(
                  title: title,
                  subtitle: subtitle,
                  flex: 1,
                );

                final newTournamentTree =
                    tournamentTree.replaceEntryAtCoordinate(i, j, entry);

                SettingsService().edit(tournamentTree: newTournamentTree);
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry?.title ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  entry?.subtitle ?? '',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
