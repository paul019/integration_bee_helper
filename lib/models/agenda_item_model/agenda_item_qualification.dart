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
    required super.progressIndex,
    required super.phaseIndex,
    required super.timer,
  }) {
    super.type = AgendaItemType.qualification;
  }

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
        status: json['status'] ?? '',
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
        progressIndex: json['progressIndex'],
        phaseIndex: json['phaseIndex'],
        timer: TimerModel.fromJson(json['timer']),
      );

  @override
  String get displayTitle => title != '' ? title : 'Qualification round';
  @override
  String get displaySubtitle =>
      'Agenda item #${orderIndex + 1} – Qualification round';

  static Map<String, dynamic> minimalJson = {
    'integralsCodes': [],
    'spareIntegralsCodes': [],
    'timeLimitPerIntegral': 5 * 60,
    'timeLimitPerSpareIntegral': 3 * 60,
    'title': '',
    'currentIntegralCode': null,
    'progressIndex': 0,
    'phaseIndex': ProblemPhase.idle.value,
    'timer': TimerModel.empty.toJson(),
  };
}
