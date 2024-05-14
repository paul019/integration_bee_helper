import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/timer_model.dart';

abstract class AgendaItemModelCompetition extends AgendaItemModel {
  // Static:
  final List<String> integralsCodes;
  final List<String> spareIntegralsCodes;
  final Duration timeLimitPerIntegral;
  final Duration timeLimitPerSpareIntegral;
  final String title;

  // Dynamic:
  final String? currentIntegralCode;
  final int progressIndex; // index of the current integral
  final ProblemPhase phaseIndex;
  final TimerModel timer;


  AgendaItemModelCompetition({
    required super.id,
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
    required this.progressIndex,
    required this.phaseIndex,
    required this.timer,
  }) {
    super.type = AgendaItemType.qualification;
  }
}