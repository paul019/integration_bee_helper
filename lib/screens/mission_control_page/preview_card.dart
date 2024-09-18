import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen.dart';
import 'package:integration_bee_helper/screens/presentation_screen_two/presentation_screen_two.dart';
import 'package:integration_bee_helper/services/settings_service/settings_service.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';
import 'package:provider/provider.dart';

class PreviewCard extends StatelessWidget {
  final AgendaItemModel? activeAgendaItem;

  const PreviewCard({super.key, required this.activeAgendaItem});

  static const double width = 850 - 4 * 8;
  static const double height = width / 1920 * 1080;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel?>(context);
    final switched = settings?.screensSwitched ?? false;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                _buildPresentationScreenBig(
                  context: context,
                  activeAgendaItem: activeAgendaItem,
                  settings: settings,
                  switched: switched,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildPresentationScreenSmall(
                          context: context,
                          activeAgendaItem: activeAgendaItem,
                          settings: settings,
                          switched: switched,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: width / 4,
                      height: height / 4,
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          SettingsService().edit(screensSwitched: !switched);
                        },
                        color: ThemeColors.red,
                        icon: const Icon(Icons.flip_camera_android),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPresentationScreenBig({
    required BuildContext context,
    required AgendaItemModel? activeAgendaItem,
    required SettingsModel? settings,
    required bool switched,
  }) {
    if (!switched) {
      return PresentationScreen(
        activeAgendaItem: activeAgendaItem,
        size: const Size(width, height),
        isPreview: true,
      );
    } else {
      return PresentationScreenTwo(
        activeAgendaItem: activeAgendaItem,
        settings: settings,
        size: const Size(width, height),
        isPreview: true,
      );
    }
  }

  Widget _buildPresentationScreenSmall({
    required BuildContext context,
    required AgendaItemModel? activeAgendaItem,
    required SettingsModel? settings,
    required bool switched,
  }) {
    if (switched) {
      return PresentationScreen(
        activeAgendaItem: activeAgendaItem,
        size: const Size(width / 4, height / 4),
        isPreview: true,
      );
    } else {
      return PresentationScreenTwo(
        activeAgendaItem: activeAgendaItem,
        settings: settings,
        size: const Size(width / 4, height / 4),
        isPreview: true,
      );
    }
  }
}
