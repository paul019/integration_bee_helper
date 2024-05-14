import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/score.dart';
import 'package:integration_bee_helper/models/timer_model.dart';

class AgendaItemModelKnockout extends AgendaItemModelCompetition {
  // Static:
  final String competitor1Name;
  final String competitor2Name;

  // Dynamic:
  final List<Score> scores;

  AgendaItemModelKnockout({
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
    required this.competitor1Name,
    required this.competitor2Name,
    required super.timeLimitPerIntegral,
    required super.timeLimitPerSpareIntegral,
    required this.scores,
    required super.progressIndex,
    required super.phaseIndex,
    required super.timer,
  }) {
    super.type = AgendaItemType.knockout;
  }

  factory AgendaItemModelKnockout.fromJson(
    Map<String, dynamic> json, {
    required String id,
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
        scores:
            (json['scores'] as List).map((v) => Score.fromValue(v)).toList(),
        progressIndex: json['progressIndex'],
        phaseIndex: json['phaseIndex'],
        timer: TimerModel.fromJson(json['timer']),
      );

  int? get competitor1Score => scores.competitor1Score;
  int? get competitor2Score => scores.competitor2Score;

  @override
  String get displayTitle {
    if (title != '') {
      return '$competitor1Name vs. $competitor2Name ($title)';
    } else {
      return '$competitor1Name vs. $competitor2Name';
    }
  }

  @override
  String get displaySubtitle =>
      'Agenda item #${orderIndex + 1} – Knockout round';

  static Map<String, dynamic> minimalJson = {
    'integralsCodes': [],
    'spareIntegralsCodes': [],
    'competitor1Name': '',
    'competitor2Name': '',
    'timeLimitPerIntegral': 5 * 60,
    'timeLimitPerSpareIntegral': 3 * 60,
    'title': '',
    'currentIntegralCode': null,
    'scores': [],
    'progressIndex': 0,
    'phaseIndex': ProblemPhase.idle.value,
    'timer': TimerModel.empty.toJson(),
  };
}
