import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/settings_page/cards/customization_card.dart';
import 'package:integration_bee_helper/screens/settings_page/cards/language_selector_card.dart';
import 'package:integration_bee_helper/screens/settings_page/cards/tournament_tree_card.dart';
import 'package:integration_bee_helper/widgets/max_width_wrapper.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AgendaItemModel? activeAgendaItem;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel?>(context);

    if (settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: MaxWidthWrapper(
        child: Column(
          children: [
            TournamentTreeCard(settings: settings),
            CustomizationCard(settings: settings),
            LanguageSelectorCard(settings: settings),
          ],
        ),
      ),
    );
  }
}
