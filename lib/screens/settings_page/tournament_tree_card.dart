import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_model.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/settings_service/settings_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';

class TournamentTreeCard extends StatefulWidget {
  final SettingsModel settings;

  const TournamentTreeCard({super.key, required this.settings});

  @override
  State<TournamentTreeCard> createState() => _TournamentTreeCardState();
}

class _TournamentTreeCardState extends State<TournamentTreeCard> {
  bool hasChanged = false;

  late String tournamentTreeString;
  late TextEditingController tournamentTreeStringController;

  @override
  void initState() {
    tournamentTreeString = widget.settings.tournamentTree.encode();
    tournamentTreeStringController =
        TextEditingController(text: tournamentTreeString);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TournamentTreeCard oldWidget) {
    tournamentTreeString = widget.settings.tournamentTree.encode();
    tournamentTreeStringController.text = tournamentTreeString;

    hasChanged = false;

    super.didUpdateWidget(oldWidget);
  }

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
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    MyIntl.S.tournamentTree,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: MyIntl.S.tournamentTree,
                ),
                controller: tournamentTreeStringController,
                onChanged: (v) => setState(() {
                  tournamentTreeString = v;
                  hasChanged = true;
                }),
                maxLines: 8,
              ),
              if (hasChanged)
                CancelSaveButtons(
                  onCancel: () {
                    setState(() {
                      hasChanged = false;
                      tournamentTreeString =
                          widget.settings.tournamentTree.encode();
                    });
                  },
                  onSave: () async {
                    await SettingsService().edit(
                      tournamentTree:
                          TournamentTreeModel.decode(tournamentTreeString),
                    );
                    setState(() => hasChanged = false);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
