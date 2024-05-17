import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/basic_models/timer_model.dart';

class AgendaItemModelQualification extends AgendaItemModelCompetition {
  AgendaItemModelQualification({
    required super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.finished = false,
    super.status = '',
    super.title = '',
    required super.integralsCodes,
    required super.spareIntegralsCodes,
    super.currentIntegralCode,
    required super.timeLimitPerIntegral,
    required super.timeLimitPerSpareIntegral,
    required super.integralsProgress,
    required super.spareIntegralsProgress,
    required super.problemPhase,
    required super.timer,
  });

  factory AgendaItemModelQualification.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) =>
      AgendaItemModelQualification(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        finished: json['finished'] ?? false,
        status: json['status'],
        title: json['title'],
        integralsCodes:
            (json['integralsCodes'] as List).map((v) => v as String).toList(),
        spareIntegralsCodes: (json['spareIntegralsCodes'] as List)
            .map((v) => v as String)
            .toList(),
        currentIntegralCode: json['currentIntegralCode'],
        timeLimitPerIntegral: Duration(seconds: json['timeLimitPerIntegral']),
        timeLimitPerSpareIntegral:
            Duration(seconds: json['timeLimitPerSpareIntegral']),
        integralsProgress: json['integralsProgress'],
        spareIntegralsProgress: json['spareIntegralsProgress'],
        problemPhase: ProblemPhase.fromValue(json['problemPhase']),
        timer: TimerModel.fromJson(json['timer']),
      );

  static Map<String, dynamic> minimalJson = {
    'type': AgendaItemType.qualification.id,
    'integralsCodes': [],
    'spareIntegralsCodes': [],
    'timeLimitPerIntegral': 5 * 60,
    'timeLimitPerSpareIntegral': 3 * 60,
    'title': '',
    'currentIntegralCode': null,
    'integralsProgress': null,
    'spareIntegralsProgress': null,
    'problemPhase': ProblemPhase.idle.value,
    'timer': TimerModel.empty.toJson(),
  };

  // Getters:
  @override
  AgendaItemType get type => AgendaItemType.qualification;
  @override
  String get displayTitle => title != '' ? title : 'Qualification round';
  @override
  String get displaySubtitle =>
      'Agenda item #${orderIndex + 1} – Qualification round';

  // Database operations:
  @override
  Future<void> checkEdit({
    List<String>? integralsCodes,
    List<String>? spareIntegralsCodes,
    Duration? timeLimitPerIntegral,
    Duration? timeLimitPerSpareIntegral,
    String? title,
  }) async {
    await super.checkEdit();

    // integralsCodes

    // Make sure, there is only one integral:
    if (integralsCodes != null) {
      if (integralsCodes.length > 1) {
        throw Exception('Qualification can have only one integral');
      }
    }
  }

  @override
  Future<void> editStatic({
    List<String>? integralsCodes,
    List<String>? spareIntegralsCodes,
    Duration? timeLimitPerIntegral,
    Duration? timeLimitPerSpareIntegral,
    String? title,
  }) async {
    await checkEdit(
      integralsCodes: integralsCodes,
      spareIntegralsCodes: spareIntegralsCodes,
      timeLimitPerIntegral: timeLimitPerIntegral,
      timeLimitPerSpareIntegral: timeLimitPerSpareIntegral,
      title: title,
    );

    await reference.update({
      'integralsCodes': integralsCodes,
      'spareIntegralsCodes': spareIntegralsCodes,
      'timeLimitPerIntegral': timeLimitPerIntegral?.inSeconds,
      'timeLimitPerSpareIntegral': timeLimitPerSpareIntegral?.inSeconds,
      'title': title,
    }.deleteNullEntries());
  }

  // Agenda item specific operations:
  Future setToFinished() async {
    await reference.update({
      'problemPhase': ProblemPhase.showSolutionAndWinner.value,
      'finished': true,
      'status': 'Qualification round finished!',
    });
  }
}
