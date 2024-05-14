part of 'agenda_items_service.dart';

extension EditAgendaItemStatic on AgendaItemsService {
  Future editAgendaItemKnockout(
    AgendaItemModelKnockout agendaItem, {
    required List<String> integralsCodes,
    required List<String> spareIntegralsCodes,
    required String competitor1Name,
    required String competitor2Name,
    required Duration timeLimitPerIntegral,
    required Duration timeLimitPerSpareIntegral,
    required String title,
  }) async {
    _checkGeneralAgendaItemEdit(agendaItem);
    await _checkCompetitionAgendaItemEdit(
      agendaItem,
      integralsCodes: integralsCodes,
      spareIntegralsCodes: spareIntegralsCodes,
      timeLimitPerIntegral: timeLimitPerIntegral,
      timeLimitPerSpareIntegral: timeLimitPerSpareIntegral,
      title: title,
    );

    await agendaItem.reference.update({
      'integralsCodes': integralsCodes,
      'spareIntegralsCodes': spareIntegralsCodes,
      'competitor1Name': competitor1Name,
      'competitor2Name': competitor2Name,
      'timeLimitPerIntegral': timeLimitPerIntegral.inSeconds,
      'timeLimitPerSpareIntegral': timeLimitPerSpareIntegral.inSeconds,
      'title': title,
    }.deleteNullEntries());
  }

  Future editAgendaItemQualification(
    AgendaItemModelQualification agendaItem, {
    required List<String> integralsCodes,
    required List<String> spareIntegralsCodes,
    required Duration timeLimitPerIntegral,
    required Duration timeLimitPerSpareIntegral,
    required String title,
  }) async {
    _checkGeneralAgendaItemEdit(agendaItem);
    await _checkCompetitionAgendaItemEdit(
      agendaItem,
      integralsCodes: integralsCodes,
      spareIntegralsCodes: spareIntegralsCodes,
      timeLimitPerIntegral: timeLimitPerIntegral,
      timeLimitPerSpareIntegral: timeLimitPerSpareIntegral,
      title: title,
    );

    if (integralsCodes.length > 1) {
      throw Exception('Qualification can have only one integral');
    }

    await agendaItem.reference.update({
      'integralsCodes': integralsCodes,
      'spareIntegralsCodes': spareIntegralsCodes,
      'timeLimitPerIntegral': timeLimitPerIntegral.inSeconds,
      'timeLimitPerSpareIntegral': timeLimitPerSpareIntegral.inSeconds,
      'title': title,
    }.deleteNullEntries());
  }

  Future editAgendaItemText(
    AgendaItemModelText agendaItem, {
    String? title,
    String? subtitle,
    String? imageUrl,
  }) async {
    _checkGeneralAgendaItemEdit(agendaItem);

    await agendaItem.reference.update({
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
    }.deleteNullEntries());
  }

  void _checkGeneralAgendaItemEdit(AgendaItemModel agendaItem) {
    // Make sure, agenda item is not finished
    if (agendaItem.finished) {
      throw Exception('Cannot edit finished agenda item');
    }
  }

  Future _checkCompetitionAgendaItemEdit(
    AgendaItemModelCompetition agendaItem, {
    required List<String> integralsCodes,
    required List<String> spareIntegralsCodes,
    required Duration timeLimitPerIntegral,
    required Duration timeLimitPerSpareIntegral,
    required String title,
  }) async {
    // Make sure, already used integrals are not edited:
    if (agendaItem.currentlyActive) {
      for (int i = 0; i <= agendaItem.integralsProgress; i++) {
        if (integralsCodes.length <= i) {
          throw Exception('Cannot edit already used integrals');
        }
        if (agendaItem.integralsCodes[i] != integralsCodes[i]) {
          throw Exception('Cannot edit already used integrals');
        }
      }
      if(agendaItem.spareIntegralsProgress > -1) {  // if spare integrals are already used
        if(integralsCodes.length > agendaItem.integralsCodes.length) {
          throw Exception('Cannot add new integrals when spare integrals are already used');
        }
      }
    }

    // Make sure, time limits are not negative:
    if (timeLimitPerIntegral.isNegative ||
        timeLimitPerSpareIntegral.isNegative) {
      throw Exception('Time limits cannot be negative');
    }

    // Check integral codes:
    final currentIntegralCodes = agendaItem.integralsCodes
        .toSet()
        .union(agendaItem.spareIntegralsCodes.toSet());
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
        await integralsService.getIntegral(code: integralCode);
      } catch (err) {
        throw Exception('Integral with code $integralCode does not exist');
      }
    }
  }
}
