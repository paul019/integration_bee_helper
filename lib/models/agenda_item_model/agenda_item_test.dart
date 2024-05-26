import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';

class AgendaItemModelTest extends AgendaItemModelCompetition {
  // Static:
  final List<String> competitorNames;

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
        title: json['title'],
      );

  static Map<String, dynamic> minimalJson = {
    'type': AgendaItemType.test.id,
    'integralsCodes': [],
    'spareIntegralsCodes': [],
    'title': '',
    'competitorNames': [],
  };

  // Getters:
  @override
  AgendaItemType get type => AgendaItemType.test;

  @override
  String get displayTitle => title;
  @override
  String get displaySubtitle => 'Agenda item #${orderIndex + 1} – Test';

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
