import 'package:flutter/material.dart';
import 'package:integration_bee_helper/extensions/exception_extension.dart';
import 'package:integration_bee_helper/models/settings_model/settings_model.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/settings_service/settings_service.dart';
import 'package:integration_bee_helper/widgets/cancel_save_buttons.dart';
import 'package:integration_bee_helper/widgets/image_upload_widget.dart';

class CustomizationCard extends StatefulWidget {
  final SettingsModel settings;

  const CustomizationCard({super.key, required this.settings});

  @override
  State<CustomizationCard> createState() => _CustomizationCardState();
}

class _CustomizationCardState extends State<CustomizationCard> {
  bool hasChanged = false;

  late String competitionName;

  late TextEditingController competitionNameController;

  @override
  void initState() {
    competitionName = widget.settings.competitionName;

    competitionNameController = TextEditingController(text: competitionName);

    super.initState();
  }

  void reset() {
    competitionName = widget.settings.competitionName;

    competitionNameController = TextEditingController(text: competitionName);

    hasChanged = false;
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
                    MyIntl.of(context).customization,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      MyIntl.of(context).competitionNameColon,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: MyIntl.of(context).competitionName,
                      ),
                      controller: competitionNameController,
                      onChanged: (v) => setState(() {
                        competitionName = v;
                        hasChanged = true;
                      }),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      MyIntl.of(context).logoColon,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ImageUploadWidget(
                    imageUrl: widget.settings.logoUrl,
                    onUpload: (image) {
                      SettingsService().uploadLogo(
                        image: image,
                        onError: (e) => e.show(context),
                      );
                    },
                    onDelete: () {
                      SettingsService().deleteLogo(
                        path: widget.settings.logoPath!,
                        onError: (e) => e.show(context),
                      );
                    },
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      MyIntl.of(context).backgroundColon,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ImageUploadWidget(
                    imageUrl: widget.settings.backgroundUrl,
                    onUpload: (image) {
                      SettingsService().uploadBackground(
                        image: image,
                        onError: (e) => e.show(context),
                      );
                    },
                    onDelete: () {
                      SettingsService().deleteBackground(
                        path: widget.settings.backgroundPath!,
                        onError: (e) => e.show(context),
                      );
                    },
                  ),
                ],
              ),
              if (hasChanged)
                CancelSaveButtons(
                  onCancel: () {
                    setState(() {
                      reset();
                    });
                  },
                  onSave: () async {
                    try {
                      await widget.settings.reference.update({
                        'competitionName': competitionName,
                      });
                      setState(() => hasChanged = false);
                    } on Exception catch (e) {
                      if (context.mounted) e.show(context);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
