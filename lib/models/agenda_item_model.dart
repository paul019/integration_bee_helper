import 'package:flutter/material.dart';

class AgendaItemModel {
  final String? id;
  final String uid;
  final int orderIndex;
  final AgendaItemType type;

  AgendaItemModel({
    this.id,
    required this.uid,
    required this.orderIndex,
    this.type = AgendaItemType.notSpecified,
  });

  factory AgendaItemModel.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) =>
      AgendaItemModel(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        type: AgendaItemType.fromString(json['type']),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'orderIndex': orderIndex,
        'type': type.id,
      };
}

enum AgendaItemType {
  notSpecified('notSpecified'),
  knockout('knockout'),
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

  static List<AgendaItemType> selectable = [AgendaItemType.knockout, AgendaItemType.text];

  IconData get icon {
    switch(this) {
      case AgendaItemType.notSpecified:
        return Icons.abc;
      case AgendaItemType.knockout:
        return Icons.people;
      case AgendaItemType.text:
        return Icons.abc;
    }
  }

  String get title {
    switch(this) {
      case AgendaItemType.notSpecified:
        return 'Not specified yet';
      case AgendaItemType.knockout:
        return 'Knockout round';
      case AgendaItemType.text:
        return 'Text';
    }
  }
}
