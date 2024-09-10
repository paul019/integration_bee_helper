import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/settings_service/settings_service.dart';
import 'package:integration_bee_helper/theme/theme_colors.dart';

class LanguageSelectorCard extends StatefulWidget {
  final SettingsModel settings;

  const LanguageSelectorCard({super.key, required this.settings});

  @override
  State<LanguageSelectorCard> createState() => _LanguageSelectorCardState();
}

class _LanguageSelectorCardState extends State<LanguageSelectorCard> {
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
                    MyIntl.of(context).language,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: SettingsModel.availableLanguages
                      .map(
                        (languageCode) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: languageCode ==
                                      widget.settings.languageCode
                                  ? MaterialStateProperty.all(ThemeColors.yellow)
                                  : null,
                            ),
                            onPressed: () async {
                              await SettingsService().edit(
                                languageCode: languageCode,
                              );
                            },
                            child: Text(languageCode),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
