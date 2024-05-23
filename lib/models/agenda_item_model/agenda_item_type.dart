import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';

enum AgendaItemType {
  notSpecified('notSpecified'),
  knockout('knockout'),
  qualification('qualification'),
  text('text');

  static AgendaItemType standard = AgendaItemType.notSpecified;

  const AgendaItemType(this.id);
  final String id;

  factory AgendaItemType.fromString(String id) {
    var type = standard;

    for (var element in AgendaItemType.values) {
      if (id == element.id) {
        type = element;
      }
    }

    return type;
  }

  static List<AgendaItemType> selectable = [
    AgendaItemType.qualification,
    AgendaItemType.knockout,
    AgendaItemType.text
  ];

  IconData get icon {
    switch (this) {
      case AgendaItemType.notSpecified:
        return Icons.abc;
      case AgendaItemType.knockout:
        return Icons.people;
      case AgendaItemType.qualification:
        return Icons.groups;
      case AgendaItemType.text:
        return Icons.abc;
    }
  }

  String get title {
    switch (this) {
      case AgendaItemType.notSpecified:
        return 'Not specified yet';
      case AgendaItemType.knockout:
        return 'Knockout round';
      case AgendaItemType.qualification:
        return 'Qualification round';
      case AgendaItemType.text:
        return 'Text';
    }
  }

  Map<String, dynamic> get minimalJson {
    switch (this) {
      case AgendaItemType.notSpecified:
        return {};
      case AgendaItemType.knockout:
        return AgendaItemModelKnockout.minimalJson;
      case AgendaItemType.qualification:
        return AgendaItemModelQualification.minimalJson;
      case AgendaItemType.text:
        return AgendaItemModelText.minimalJson;
    }
  }

  bool get isCompetition =>
      this == AgendaItemType.knockout || this == AgendaItemType.qualification;
}
