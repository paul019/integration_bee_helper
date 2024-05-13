import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/score_model.dart';
import 'package:integration_bee_helper/models/timer_model.dart';

class AgendaItemModelKnockout extends AgendaItemModel {
  // Static:
  final List<String> integralsCodes;
  final List<String> spareIntegralsCodes;
  final String competitor1Name;
  final String competitor2Name;
  final Duration timeLimitPerIntegral;
  final Duration timeLimitPerSpareIntegral;
  final String title;

  // Dynamic:
  final String? currentIntegralCode;
  final List<ScoreModel>? scores;
  final int? progressIndex; // index of the current integral
  final ProblemPhase? phaseIndex;
  final TimerModel? timer;

  AgendaItemModelKnockout({
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
    required this.competitor1Name,
    required this.competitor2Name,
    required this.timeLimitPerIntegral,
    required this.timeLimitPerSpareIntegral,
    this.scores,
    this.progressIndex,
    this.phaseIndex,
    this.timer,
  }) {
    super.type = AgendaItemType.knockout;
  }

  factory AgendaItemModelKnockout.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) =>
      AgendaItemModelKnockout(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        finished: json['finished'] ?? false,
        status: json['status'] ?? '',
        title: json['title'] ?? '',
        integralsCodes:
            (json['integralsCodes'] as List).map((v) => v as String).toList(),
        spareIntegralsCodes: (json['spareIntegralsCodes'] as List)
            .map((v) => v as String)
            .toList(),
        currentIntegralCode: json['currentIntegralCode'],
        competitor1Name: json['competitor1Name'],
        competitor2Name: json['competitor2Name'],
        timeLimitPerIntegral: Duration(seconds: json['timeLimitPerIntegral']),
        timeLimitPerSpareIntegral:
            Duration(seconds: json['timeLimitPerSpareIntegral']),
        scores: json['scores'] != null
            ? (json['scores'] as List)
                .map((v) => ScoreModel.fromValue(v))
                .toList()
            : null,
        progressIndex: json['progressIndex'],
        phaseIndex: json['phaseIndex'],
        timer:
            json['timer'] != null ? TimerModel.fromJson(json['timer']) : null,
      );

  int? get competitor1Score => scores?.competitor1Score;
  int? get competitor2Score => scores?.competitor2Score;

  @override
  String get displayTitle {
    if (title != '') {
      return '$competitor1Name vs. $competitor2Name ($title)';
    } else {
      return '$competitor1Name vs. $competitor2Name';
    }
  }
  @override
  String get displaySubtitle => 'Agenda item #${orderIndex + 1} – Knockout round';
}
