import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';

abstract class AgendaItemModelCompetition extends AgendaItemModel {
  // Static:
  final List<String> integralsCodes;
  final List<String> spareIntegralsCodes;
  final String title;

  AgendaItemModelCompetition({
    required super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.phase = AgendaItemPhase.idle,
    super.status = '',
    this.title = '',
    required this.integralsCodes,
    required this.spareIntegralsCodes,
  });

  // Getters:
  int get numOfIntegrals => integralsCodes.length;

  // Database operations:
  @override
  Future<void> checkEdit({
    List<String>? integralsCodes,
    List<String>? spareIntegralsCodes,
    String? title,
  }) async {
    await super.checkEdit();

    integralsCodes ??= this.integralsCodes;
    spareIntegralsCodes ??= this.spareIntegralsCodes;

    // Check integral codes:
    final currentIntegralCodes =
        this.integralsCodes.toSet().union(this.spareIntegralsCodes.toSet());
    final editedIntegralCodes = [...integralsCodes, ...spareIntegralsCodes];
    final newIntegralCodes =
        editedIntegralCodes.toSet().difference(currentIntegralCodes);

    // Make sure, integral codes are not doubled:
    if (editedIntegralCodes.toSet().length != editedIntegralCodes.length) {
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
  Future start(WriteBatch batch) async {
    batch.update(reference, {
      'currentlyActive': true,
      'phase': AgendaItemPhase.activeButFinished.value,
      'status': null,
    });
  }

  Future updateAgendaItemIdsInIntegrals({
    required List<String>? integralsCodes,
    required List<String>? spareIntegralsCodes,
  }) async {
    final newRegularIntegralsCodes = integralsCodes ?? this.integralsCodes;
    final newSpareIntegralsCodes =
        spareIntegralsCodes ?? this.spareIntegralsCodes;

    final newIntegralCodes = {
      ...newRegularIntegralsCodes,
      ...newSpareIntegralsCodes
    };
    final currentIntegralCodes = {
      ...this.integralsCodes,
      ...this.spareIntegralsCodes
    };

    final addedIntegralCodes =
        newIntegralCodes.difference(currentIntegralCodes);
    final removedIntegralCodes =
        currentIntegralCodes.difference(newIntegralCodes);

    for (var integralCode in addedIntegralCodes) {
      final integral = await IntegralsService().getIntegral(code: integralCode);
      await integral.reference.update({
        'agendaItemIds': FieldValue.arrayUnion([id]),
      });
    }

    for (var integralCode in removedIntegralCodes) {
      final integral = await IntegralsService().getIntegral(code: integralCode);
      await integral.reference.update({
        'agendaItemIds': FieldValue.arrayRemove([id]),
      });
    }
  }
}
