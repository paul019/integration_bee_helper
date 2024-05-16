import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/score.dart';
import 'package:integration_bee_helper/models/basic_models/timer_model.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';

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
    required super.integralsProgress,
    required super.spareIntegralsProgress,
    required super.problemPhase,
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
        status: json['status'],
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
        integralsProgress: json['integralsProgress'],
        spareIntegralsProgress: json['spareIntegralsProgress'],
        problemPhase: json['problemPhase'],
        timer: TimerModel.fromJson(json['timer']),
      );

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
    'integralsProgress': null,
    'spareIntegralsProgress': null,
    'problemPhase': ProblemPhase.idle.value,
    'timer': TimerModel.empty.toJson(),
  };

  // Getters:
  int get competitor1Score => scores.competitor1Score;
  int get competitor2Score => scores.competitor2Score;
  Score get currentWinner => _getWinner(competitor1Score, competitor2Score);

  Score _getWinner(int competitor1Score, int competitor2Score) {
    if (competitor1Score > numOfIntegrals / 2.0 &&
        competitor1Score > competitor2Score) {
      return Score.competitor1;
    } else if (competitor2Score > numOfIntegrals / 2.0 &&
        competitor2Score > competitor1Score) {
      return Score.competitor2;
    } else {
      return Score.notSetYet;
    }
  }

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

  // Database operations:
  @override
  Future<void> editStatic({
    List<String>? integralsCodes,
    List<String>? spareIntegralsCodes,
    String? competitor1Name,
    String? competitor2Name,
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
      'competitor1Name': competitor1Name,
      'competitor2Name': competitor2Name,
      'timeLimitPerIntegral': timeLimitPerIntegral?.inSeconds,
      'timeLimitPerSpareIntegral': timeLimitPerSpareIntegral?.inSeconds,
      'title': title,
    }.deleteNullEntries());
  }

  @override
  void reset(WriteBatch batch) {
    super.reset(batch);

    batch.update(reference, {
      'scores': [],
    });
  }

  @override
  void start(WriteBatch batch) {
    super.start(batch);

    batch.update(reference, {
      'scores': [Score.notSetYet],
    });
  }

  // Agenda item specific operations:
  Future setWinner(Score winner) async {
    var scores = this.scores;
    scores[totalProgress!] = winner;

    final competitor1Score = scores.competitor1Score;
    final competitor2Score = scores.competitor2Score;

    bool finished = false;
    String? status;

    switch (_getWinner(competitor1Score, competitor2Score)) {
      case Score.competitor1:
        status = '$competitor1Name wins!';
        finished = true;
        break;
      case Score.competitor2:
        status = '$competitor2Name wins!';
        finished = true;
        break;
      default:
        break;
    }

    await reference.update({
      'finished': finished,
      'status': status,
      'scores': scores,
      'problemPhase': ProblemPhase.showSolutionAndWinner,
      'timer': null,
    });
  }

  Future startNextRegularIntegral() async {
    var scores = [...this.scores];
    final nextIntegralCode = integralsCodes[integralsProgress! + 1];

    // Add score element:
    scores.add(Score.notSetYet);

    // Set next integral to used:
    await IntegralsService().setIntegralToUsed(nextIntegralCode);

    await reference.update({
      'scores': scores,
      'integralsProgress': integralsProgress! + 1,
      'problemPhase': ProblemPhase.idle.value,
      'timer': TimerModel.empty.toJson(),
      'currentIntegralCode': nextIntegralCode,
    });

    return true;
  }
}
