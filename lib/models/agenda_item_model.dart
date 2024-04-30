import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgendaItemModel {
  final String? id;
  final String uid;
  final int orderIndex;
  final AgendaItemType type;
  final bool currentlyActive;
  final bool finished;
  final String status;

  // Text:
  final String? title;
  final String? subtitle;

  // Knockout round:
  final List<String>? integralsCodes;
  final List<String>? spareIntegralsCodes;
  final String? currentIntegralCode;
  final String? competitor1Name;
  final String? competitor2Name;
  final Duration? timeLimitPerIntegral;
  final Duration? timeLimitPerSpareIntegral;

  final List<int>? scores;
  // -1: not set yet
  // 0: tie
  // 1: competitor 1
  // 2: competitor 2
  final int? progressIndex;
  // index of the current integral
  final int? phaseIndex;
  // 0: Show ???
  // 1: Show problem and start timer
  // 2: Show solution
  // 3: Show solution and winner of this round
  final DateTime? timerStopsAt;
  final Duration? pausedTimerDuration;

  AgendaItemModel({
    this.id,
    required this.uid,
    required this.orderIndex,
    this.type = AgendaItemType.notSpecified,
    this.currentlyActive = false,
    this.finished = false,
    this.status = '',

    // Text:
    this.title,
    this.subtitle,

    // Knockout round:
    this.integralsCodes,
    this.spareIntegralsCodes,
    this.currentIntegralCode,
    this.competitor1Name,
    this.competitor2Name,
    this.timeLimitPerIntegral,
    this.timeLimitPerSpareIntegral,
    this.scores,
    this.progressIndex,
    this.phaseIndex,
    this.timerStopsAt,
    this.pausedTimerDuration,
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
        finished: json['finished'] ?? false,
        status: json['status'] ?? '',

        // Text:
        title: json['title'],
        subtitle: json['subtitle'],

        // Knockout round:
        integralsCodes: json['integralsCodes'] != null
            ? (json['integralsCodes'] as List).map((v) => v as String).toList()
            : null,
        spareIntegralsCodes: json['spareIntegralsCodes'] != null
            ? (json['spareIntegralsCodes'] as List)
                .map((v) => v as String)
                .toList()
            : null,
        currentIntegralCode: json['currentIntegralCode'],
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
        pausedTimerDuration: json['pausedTimerDuration'] != null
            ? Duration(seconds: json['pausedTimerDuration'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'orderIndex': orderIndex,
        'type': type.id,
        'currentlyActive': currentlyActive,
      };

  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('agendaItems');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(id!);

  int? get competitor1Score {
    if (scores == null) {
      return null;
    }

    return scores!.where((x) => x == 1).length;
  }

  int? get competitor2Score {
    if (scores == null) {
      return null;
    }

    return scores!.where((x) => x == 2).length;
  }

  String get displayTitle {
    switch (type) {
      case AgendaItemType.notSpecified:
        return 'Not specified yet';
      case AgendaItemType.knockout:
        return '$competitor1Name vs. $competitor2Name';
      case AgendaItemType.text:
        return title!;
    }
  }

  String get displaySubtitle {
    switch (type) {
      case AgendaItemType.notSpecified:
        return 'Agenda item #${orderIndex + 1}';
      case AgendaItemType.knockout:
        return 'Agenda item #${orderIndex + 1} – Knockout round';
      case AgendaItemType.text:
        return 'Agenda item #${orderIndex + 1} – Text';
    }
  }
}

enum AgendaItemType {
  notSpecified('notSpecified'),
  knockout('knockout'),
  //qualification('qualification'),
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
