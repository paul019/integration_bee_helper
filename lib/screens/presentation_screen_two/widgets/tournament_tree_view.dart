import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_entry.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_model.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';

class TournamentTreeView extends StatelessWidget {
  final TournamentTreeModel tournamentTreeModel;
  final Size size;

  const TournamentTreeView({
    super.key,
    required this.tournamentTreeModel,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    if (tournamentTreeModel.isEmpty) {
      return Container();
    }

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(200 * p),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (var stage in tournamentTreeModel.stages)
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    for (var entry in stage.entries)
                      _buildEntry(context, entry),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntry(BuildContext context, TournamentTreeEntry entry) {
    final p = size.width / 1920.0;

    return Flexible(
      flex: entry.flex,
      child: entry.isEmpty
          ? const Row()
          : Padding(
              padding: EdgeInsets.all(8 * p),
              child: Container(
                color: ThemeColors.blue,
                child: Padding(
                  padding: EdgeInsets.all(8 * p),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            entry.title,
                            style: TextStyle(
                              fontSize: 30 * p,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (entry.subtitle.isNotEmpty)
                        Text(
                          entry.subtitle,
                          style: TextStyle(
                            fontSize: 20 * p,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
