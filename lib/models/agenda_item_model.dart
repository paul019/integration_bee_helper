import 'package:flutter/material.dart';

class AgendaItemModel {
  final String? id;
  final String uid;
  final int orderIndex;
  final AgendaItemType type;
  final bool currentlyActive;

  // Text:
  final String? text;

  // Knockout round:
  final List<String>? integralsCodes;
  final List<String>? spareIntegralsCodes;
  final String? competitor1Name;
  final String? competitor2Name;
  final Duration? timeLimitPerIntegral;
  final Duration? timeLimitPerSpareIntegral;

  final List<int>? scores;
  final int? progressIndex;
  final int? phaseIndex;
  final DateTime? timerStopsAt;

  AgendaItemModel({
    this.id,
    required this.uid,
    required this.orderIndex,
    this.type = AgendaItemType.notSpecified,
    this.currentlyActive = false,

    // Text:
    this.text,

    // Knockout round:
    this.integralsCodes,
    this.spareIntegralsCodes,
    this.competitor1Name,
    this.competitor2Name,
    this.timeLimitPerIntegral,
    this.timeLimitPerSpareIntegral,
    this.scores,
    this.progressIndex,
    this.phaseIndex,
    this.timerStopsAt,
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
        currentlyActive: json['currentlyActive'],

        // Text:
        text: json['text'],

        // Knockout round:
        integralsCodes: json['integralsCodes'] != null
            ? (json['integralsCodes'] as List).map((v) => v as String).toList()
            : null,
        spareIntegralsCodes: json['spareIntegralsCodes'] != null
            ? (json['spareIntegralsCodes'] as List)
                .map((v) => v as String)
                .toList()
            : null,
        competitor1Name: json['competitor1Name'],
        competitor2Name: json['competitor2Name'],
        timeLimitPerIntegral: json['timeLimitPerIntegral'] != null
            ? Duration(seconds: json['timeLimitPerIntegral'])
            : null,
        timeLimitPerSpareIntegral: json['timeLimitPerSpareIntegral'] != null
            ? Duration(seconds: json['timeLimitPerSpareIntegral'])
            : null,

        scores: json['scores'] != null
            ? (json['scores'] as List).map((v) => v as int).toList()
            : null,
        progressIndex: json['progressIndex'],
        phaseIndex: json['phaseIndex'],
        timerStopsAt: json['timerStopsAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['timerStopsAt'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'orderIndex': orderIndex,
        'type': type.id,
        'currentlyActive': currentlyActive,
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

  static List<AgendaItemType> selectable = [
    AgendaItemType.knockout,
    AgendaItemType.text
  ];

  IconData get icon {
    switch (this) {
      case AgendaItemType.notSpecified:
        return Icons.abc;
      case AgendaItemType.knockout:
        return Icons.people;
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
      case AgendaItemType.text:
        return 'Text';
    }
  }
}
