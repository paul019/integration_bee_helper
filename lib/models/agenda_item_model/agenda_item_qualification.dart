import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/timer_model.dart';

class AgendaItemModelQualification extends AgendaItemModel {
  // Static:
  final List<String> integralsCodes;
  final List<String> spareIntegralsCodes;
  final Duration timeLimitPerIntegral;
  final Duration timeLimitPerSpareIntegral;
  final String title;

  // Dynamic:
  final String? currentIntegralCode;
  final int? progressIndex; // index of the current integral
  final ProblemPhase? phaseIndex;
  final TimerModel? timer;

  AgendaItemModelQualification({
    super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.finished = false,
    super.status = '',
    this.title = '',
    required this.integralsCodes,
    required this.spareIntegralsCodes,
    this.currentIntegralCode,
    required this.timeLimitPerIntegral,
    required this.timeLimitPerSpareIntegral,
    this.progressIndex,
    this.phaseIndex,
    this.timer,
  }) {
    super.type = AgendaItemType.qualification;
  }

  factory AgendaItemModelQualification.fromJson(
    Map<String, dynamic> json, {
    String? id,
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
        timer:
            json['timer'] != null ? TimerModel.fromJson(json['timer']) : null,
      );

  @override
  String get displayTitle => title != '' ? title : 'Qualification round';
  @override
  String get displaySubtitle =>
      'Agenda item #${orderIndex + 1} – Qualification round';
}
