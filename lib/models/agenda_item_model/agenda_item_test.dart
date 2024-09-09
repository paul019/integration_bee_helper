import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';

class AgendaItemModelTest extends AgendaItemModelCompetition {
  // Static:
  final List<String> competitorNames;
  final String remarks;

  AgendaItemModelTest({
    required super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.phase = AgendaItemPhase.idle,
    super.status = '',
    required super.integralsCodes,
    super.spareIntegralsCodes = const [],
    required this.competitorNames,
    required this.remarks,
    super.title = '',
  });

  factory AgendaItemModelTest.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) =>
      AgendaItemModelTest(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        phase: AgendaItemPhase.fromValue(json['phase']),
        status: json['status'],
        integralsCodes:
            (json['integralsCodes'] as List).map((v) => v as String).toList(),
        competitorNames:
            (json['competitorNames'] as List).map((v) => v as String).toList(),
        remarks: json['remarks'] ?? '',
        title: json['title'],
      );

  static Map<String, dynamic> minimalJson = {
    'type': AgendaItemType.test.id,
    'integralsCodes': [],
    'spareIntegralsCodes': [],
    'title': '',
    'competitorNames': [],
    'remarks':
        r"""Dieser Qualifikations-Test enthält 20 Aufgaben, die innerhalb von 20 Minuten gelöst werden dürfen.
Bei den Aufgaben handelt es sich um bestimmte Integrale -- die Lösungen sind also nur Zahlenwerte.
Die Aufgaben sind bewusst so zusammengestellt, dass vermutlich nicht alle innerhalb der vorgegebenen Zeit gelöst werden können.
Jede Aufgabe zählt gleich viel; es gibt genau dann einen Punkt auf eine Aufgabe, wenn die Lösung korrekt ist.
Jede Lösung muss eingekreist werden. Es werden nur eingekreiste Lösungen gewertet. Ist mehr als eine Lösung eingekreist, so kann kein Punkt vergeben werden.
Falls es nicht offensichtlich ist, schreibt an eine Lösung die Nummer der zugehörigen Aufgabe.
Der Test darf erst geöffnet werden, wenn die Jury den Test startet. Sobald die Zeit abgelaufen ist, müssen alle Teilnehmenden sofort aufhören, zu schreiben.""",
  };

  // Getters:
  @override
  AgendaItemType get type => AgendaItemType.test;

  @override
  String get displayTitle => title;
  @override
  String get displaySubtitle => 'Agenda item #${orderIndex + 1} – Test';

  String get remarksFormatted {
    var formatted = '';

    for (var line in remarks.split('\n')) {
      formatted += r'\item ' + line;
    }

    return formatted;
  }

  // Database operations:
  @override
  Future<void> editStatic({
    List<String>? integralsCodes,
    List<String>? spareIntegralsCodes,
    String? title,
    List<String>? competitorNames,
  }) async {
    await checkEdit(
      integralsCodes: integralsCodes,
      spareIntegralsCodes: spareIntegralsCodes,
      title: title,
    );

    await reference.update({
      'integralsCodes': integralsCodes,
      'spareIntegralsCodes': spareIntegralsCodes,
      'title': title,
      'competitorNames': competitorNames,
    }.deleteNullEntries());

    await updateAgendaItemIdsInIntegrals(
      integralsCodes: integralsCodes,
      spareIntegralsCodes: spareIntegralsCodes,
    );
  }

  @override
  Future<void> beforeDelete() async {
    await editStatic(
      integralsCodes: [],
      spareIntegralsCodes: [],
    );
  }

  @override
  Future start(WriteBatch batch) async {
    batch.update(reference, {
      'currentlyActive': true,
      'phase': AgendaItemPhase.activeButFinished.value,
      'status': null,
    });
  }
}
