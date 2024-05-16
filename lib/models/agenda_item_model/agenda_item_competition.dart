import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/basic_models/timer_model.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';

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

  // Getters:
  int get integralsProgress => min(progressIndex, integralsCodes.length);
  int get spareIntegralsProgress =>
      max(-1, progressIndex - integralsCodes.length);

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

    // Make sure, already used integrals are not edited:
    if (currentlyActive && integralsCodes != null) {
      for (int i = 0; i <= integralsProgress; i++) {
        if (integralsCodes.length <= i) {
          throw Exception('Cannot edit already used integrals');
        }
        if (this.integralsCodes[i] != integralsCodes[i]) {
          throw Exception('Cannot edit already used integrals');
        }
      }
      if (spareIntegralsProgress > -1) {
        // if spare integrals are already used
        if (integralsCodes.length > this.integralsCodes.length) {
          throw Exception(
              'Cannot add new integrals when spare integrals are already used');
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

    integralsCodes ??= this.integralsCodes;
    spareIntegralsCodes ??= this.spareIntegralsCodes;

    // Check integral codes:
    final currentIntegralCodes =
        this.integralsCodes.toSet().union(this.spareIntegralsCodes.toSet());
    final editedIntegralCodes =
        integralsCodes.toSet().union(spareIntegralsCodes.toSet());
    final newIntegralCodes =
        editedIntegralCodes.difference(currentIntegralCodes);

    // Make sure, integral codes are not doubled:
    if (currentIntegralCodes.toSet().length != currentIntegralCodes.length) {
      throw Exception('Integral codes cannot be doubled');
    }

    // Make sure, new integral codes exist:
    for (String integralCode in newIntegralCodes) {
      try {
        await IntegralsService().getIntegral(code: integralCode);
      } catch (err) {
        throw Exception('Integral with code $integralCode does not exist');
      }
    }
  }

  @override
  void reset(WriteBatch batch) {
    super.reset(batch);

    batch.update(reference, {
      'currentIntegralCode': null,
      'progressIndex': 0,
      'phaseIndex': ProblemPhase.idle.value,
      'timer': TimerModel.empty.toJson(),
    });
  }

  @override
  void start(WriteBatch batch) {
    super.start(batch);
    
    batch.update(reference, {
      'currentIntegralCode': integralsCodes.firstOrNull,
      'progressIndex': 0,
      'phaseIndex': ProblemPhase.idle.value,
      'timer': TimerModel.empty.toJson(),
    });
  }
}
