import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
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
    super.phase = AgendaItemPhase.idle,
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
  });

  factory AgendaItemModelKnockout.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) =>
      AgendaItemModelKnockout(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        phase: AgendaItemPhase.fromValue(json['phase']),
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
        problemPhase: ProblemPhase.fromValue(json['problemPhase']),
        timer: TimerModel.fromJson(json['timer']),
      );

  static Map<String, dynamic> minimalJson = {
    'type': AgendaItemType.knockout.id,
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
  @override
  AgendaItemType get type => AgendaItemType.knockout;
  int get competitor1Score => scores.competitor1Score;
  int get competitor2Score => scores.competitor2Score;
  Score get currentWinner => _getWinner(competitor1Score, competitor2Score);

  Score _getWinner(int competitor1Score, int competitor2Score) {
    if (competitor1Score > (numOfIntegrals - scores.tieCount) / 2.0 &&
        competitor1Score > competitor2Score) {
      return Score.competitor1;
    } else if (competitor2Score > (numOfIntegrals - scores.tieCount) / 2.0 &&
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

    if (this.integralsCodes.isEmpty && (integralsCodes?.isNotEmpty ?? false)) {
      await reference.update({
        'currentIntegralCode': integralsCodes!.first,
      });
    }

    await updateAgendaItemIdsInIntegrals(
      integralsCodes: integralsCodes,
      spareIntegralsCodes: spareIntegralsCodes,
    );
  }

  @override
  void reset(WriteBatch batch) {
    super.reset(batch);

    batch.update(reference, {
      'scores': [],
    });
  }

  @override
  Future start(WriteBatch batch) async {
    await super.start(batch);

    batch.update(reference, {
      'scores': [Score.notSetYet.value],
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
      'phase': finished
          ? AgendaItemPhase.activeButFinished.value
          : AgendaItemPhase.active.value,
      'status': status,
      'scores': scores.toJson(),
      'problemPhase': ProblemPhase.showSolutionAndWinner.value,
      'timer': TimerModel.empty.toJson(),
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
      'scores': scores.toJson(),
      'integralsProgress': integralsProgress! + 1,
      'problemPhase': ProblemPhase.idle.value,
      'timer': TimerModel.empty.toJson(),
      'currentIntegralCode': nextIntegralCode,
    });

    return true;
  }

  @override
  Future startNextSpareIntegral(String spareIntegralCode) async {
    var scores = [...this.scores];

    // Add score element:
    scores.add(Score.notSetYet);

    // Set next integral to used:
    await IntegralsService().setIntegralToUsed(spareIntegralCode);

    await reference.update({
      'scores': scores.toJson(),
      'spareIntegralsProgress': (spareIntegralsProgress ?? -1) + 1,
      'problemPhase': ProblemPhase.idle.value,
      'timer': TimerModel.empty.toJson(),
      'currentIntegralCode': spareIntegralCode,
    });
  }
}
