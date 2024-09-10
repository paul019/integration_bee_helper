import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/tournament_tree_model/tournament_tree_entry.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class TournamentTreeEntryEditor extends StatefulWidget {
  final TournamentTreeEntry? entry;
  final void Function(String, String) onSave;

  const TournamentTreeEntryEditor({
    super.key,
    required this.entry,
    required this.onSave,
  });

  static void show({
    required BuildContext context,
    required TournamentTreeEntry? entry,
    required void Function(String, String) onSave,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return TournamentTreeEntryEditor(
          entry: entry,
          onSave: onSave,
        );
      },
    );
  }

  @override
  State<TournamentTreeEntryEditor> createState() =>
      _TournamentTreeEntryEditorState();
}

class _TournamentTreeEntryEditorState extends State<TournamentTreeEntryEditor> {
  late String title;
  late String subtitle;

  late TextEditingController titleController;
  late TextEditingController subtitleController;

  @override
  void initState() {
    title = widget.entry?.title ?? '';
    subtitle = widget.entry?.subtitle ?? '';

    titleController = TextEditingController(text: title);
    subtitleController = TextEditingController(text: subtitle);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: AlertDialog(
        title: Text(MyIntl.of(context).editTournamentTreeEntry),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: MyIntl.of(context).title,
              ),
              controller: titleController,
              onChanged: (v) => setState(() {
                title = v;
              }),
              maxLines: 1,
            ),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: MyIntl.of(context).subtitle,
              ),
              controller: subtitleController,
              onChanged: (v) => setState(() {
                subtitle = v;
              }),
              maxLines: 1,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(MyIntl.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              widget.onSave(title, subtitle);
              Navigator.of(context).pop();
            },
            child: Text(MyIntl.of(context).save),
          ),
        ],
      ),
    );
  }
}
