import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/integral_model/integral_model.dart';
import 'package:integration_bee_helper/models/integral_model/integral_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/basic_models/timer_model.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';

abstract class AgendaItemModelLiveCompetition
    extends AgendaItemModelCompetition {
  // Static:
  final Duration timeLimitPerIntegral;
  final Duration timeLimitPerSpareIntegral;

  // Dynamic:
  final String? currentIntegralCode;
  final int? integralsProgress;
  final int? spareIntegralsProgress;
  final ProblemPhase problemPhase;
  final TimerModel timer;

  AgendaItemModelLiveCompetition({
    required super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.phase = AgendaItemPhase.idle,
    super.status = '',
    super.title = '',
    required super.integralsCodes,
    required super.spareIntegralsCodes,
    this.currentIntegralCode,
    required this.timeLimitPerIntegral,
    required this.timeLimitPerSpareIntegral,
    required this.integralsProgress,
    required this.spareIntegralsProgress,
    required this.problemPhase,
    required this.timer,
  });

  // Getters:
  IntegralType get currentIntegralType => spareIntegralsProgress != null
      ? IntegralType.spare
      : IntegralType.regular;
  IntegralType get nextIntegralType => currentIntegralType == IntegralType.spare
      ? IntegralType.spare
      : (integralsProgress ?? 0) + 1 < numOfIntegrals
          ? IntegralType.regular
          : IntegralType.spare;
  Duration get timeLimit => currentIntegralType == IntegralType.spare
      ? timeLimitPerSpareIntegral
      : timeLimitPerIntegral;
  int? get totalProgress => spareIntegralsProgress != null
      ? numOfIntegrals + spareIntegralsProgress!
      : integralsProgress;

  // Database operations:
  @override
  Future<void> checkEdit({
    List<String>? integralsCodes,
    List<String>? spareIntegralsCodes,
    Duration? timeLimitPerIntegral,
    Duration? timeLimitPerSpareIntegral,
    String? title,
  }) async {
    await super.checkEdit(
      integralsCodes: integralsCodes,
      spareIntegralsCodes: spareIntegralsCodes,
      title: title,
    );

    // integralsCodes

    // Make sure, already used integrals are not edited:
    if (currentlyActive && integralsCodes != null) {
      for (int i = 0; i <= (integralsProgress ?? -1); i++) {
        if (integralsCodes.length <= i) {
          throw Exception('Cannot edit already used integrals');
        }
        if (this.integralsCodes.isNotEmpty &&
            this.integralsCodes[i] != integralsCodes[i]) {
          throw Exception('Cannot edit already used integrals');
        }
      }
      if (currentIntegralType == IntegralType.spare) {
        // if spare integrals are already used
        if (integralsCodes.length > this.integralsCodes.length) {
          throw Exception(
            'Cannot add new integrals when spare integrals are already used',
          );
        }
      }
    }

    // timeLimitPerIntegral

    // Make sure, time limits are not negative:
    if (timeLimitPerIntegral != null) {
      if (timeLimitPerIntegral.isNegative) {
        throw Exception('Time limits cannot be negative');
      }
    }

    // timeLimitPerSpareIntegral

    // Make sure, time limits are not negative:
    if (timeLimitPerSpareIntegral != null) {
      if (timeLimitPerSpareIntegral.isNegative) {
        throw Exception('Time limits cannot be negative');
      }
    }
  }

  @override
  void reset(WriteBatch batch) {
    super.reset(batch);

    batch.update(reference, {
      'currentIntegralCode': null,
      'integralsProgress': null,
      'spareIntegralsProgress': null,
      'problemPhase': ProblemPhase.idle.value,
      'timer': TimerModel.empty.toJson(),
    });
  }

  @override
  Future start(WriteBatch batch) async {
    await super.start(batch);

    if (integralsCodes.isNotEmpty) {
      await IntegralsService().setIntegralToUsed(integralsCodes.first);
    }

    batch.update(reference, {
      'currentIntegralCode': integralsCodes.firstOrNull,
      'integralsProgress': 0,
      'spareIntegralsProgress': null,
      'problemPhase': ProblemPhase.idle.value,
      'timer': TimerModel.empty.toJson(),
    });
  }

  // Agenda item specific operations:
  Future startIntegral() async {
    DateTime timerStopsAt = DateTime.now().add(timeLimit);

    if (currentIntegralCode == null) {
      throw Exception('You have to add at least one integral!');
    } else if (integralsProgress == 0) {
      await IntegralsService().setIntegralToUsed(integralsCodes.first);
    }

    await reference.update({
      'problemPhase': ProblemPhase.showProblem.value,
      'timer': TimerModel(timerStopsAt: timerStopsAt).toJson(),
    });
  }

  Future pauseTimer() async {
    await reference.update({
      'timer': timer.pause().toJson(),
    });
  }

  Future resumeTimer() async {
    await reference.update({
      'timer': timer.resume().toJson(),
    });
  }

  Future showSolution() async {
    await reference.update({
      'problemPhase': ProblemPhase.showSolution.value,
      'timer': TimerModel.empty.toJson(),
    });
  }

  Future<List<IntegralModel>> getPotentialSpareIntegrals() async {
    final allUnusedIntegrals = (await IntegralsService().getUnusedIntegrals());
    final allUnusedIntegralsCodes =
        allUnusedIntegrals.map((e) => e.code).toSet();
    final allUnusedSpareIntegrals = allUnusedIntegrals
        .where((integral) => integral.type == IntegralType.spare);
    final allUnusedSpareIntegralsCodes =
        allUnusedSpareIntegrals.map((e) => e.code).toSet();

    final ownUnusedSpareIntegralsCodes = spareIntegralsCodes
        .where((code) => allUnusedIntegralsCodes.contains(code))
        .toList();

    final finalList = [
      ...ownUnusedSpareIntegralsCodes,
      ...allUnusedSpareIntegralsCodes.difference(
        ownUnusedSpareIntegralsCodes.toSet(),
      ),
    ];

    if (finalList.isEmpty) throw Exception('No spare integrals available!');

    return await IntegralsService().getIntegralsByCodes(codes: finalList);
  }

  Future startNextSpareIntegral(String spareIntegralCode) async {
    await IntegralsService().setIntegralToUsed(spareIntegralCode);

    await reference.update({
      'spareIntegralsProgress': (spareIntegralsProgress ?? -1) + 1,
      'problemPhase': ProblemPhase.idle.value,
      'timer': TimerModel.empty.toJson(),
      'currentIntegralCode': spareIntegralCode,
    });
  }
}
