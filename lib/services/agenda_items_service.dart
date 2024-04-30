import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';
import 'package:integration_bee_helper/models/integral_model.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';

class AgendaItemsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;

  AgendaItemsService({required this.uid});

  AgendaItemModel? _agendaItemFromFirebase(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    if (doc.data() != null) {
      return AgendaItemModel.fromJson(doc.data()!, id: doc.id);
    } else {
      return null;
    }
  }

  List<AgendaItemModel> _agendaItemListFromFirebase(
    QuerySnapshot<Map<String, dynamic>> querySnapshot,
  ) {
    List<AgendaItemModel> list = [];

    for (var element in querySnapshot.docs) {
      final item = _agendaItemFromFirebase(element);

      if (item != null) {
        list.add(item);
      }
    }

    return list;
  }

  Stream<List<AgendaItemModel>> get onAgendaItemsChanged {
    return _firestore
        .collection('agendaItems')
        .where('uid', isEqualTo: uid)
        .orderBy('orderIndex')
        .snapshots()
        .map(_agendaItemListFromFirebase);
  }

  Stream<List<AgendaItemModel>> get onActiveAgendaItemChanged {
    return _firestore
        .collection('agendaItems')
        .where('uid', isEqualTo: uid)
        .where('currentlyActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map(_agendaItemListFromFirebase);
  }

  Future<List<AgendaItemModel>> getActiveAgendaItems() async {
    final activeItems = await _firestore
        .collection('agendaItems')
        .where('uid', isEqualTo: uid)
        .where('currentlyActive', isEqualTo: true)
        .get();

    return _agendaItemListFromFirebase(activeItems);
  }

  void addAgendaItem({
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    // Create agenda item:
    final agendaItem = AgendaItemModel(
      uid: uid,
      orderIndex: currentAgendaItems.length,
      currentlyActive: currentAgendaItems.isEmpty,
    );

    // Add agenda item:
    await AgendaItemModel.collection.add(agendaItem.toJson());
  }

  Future deleteAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    final batch = _firestore.batch();

    batch.delete(agendaItem.reference);

    if (agendaItem.currentlyActive) {
      final i = agendaItem.orderIndex;
      if (i + 1 < currentAgendaItems.length) {
        batch.update(
          _firestore
              .collection('agendaItems')
              .doc(currentAgendaItems[i + 1].id!),
          {
            'currentlyActive': true,
          },
        );
      } else if (currentAgendaItems.length >= 2) {
        batch.update(
          _firestore
              .collection('agendaItems')
              .doc(currentAgendaItems[currentAgendaItems.length - 2].id!),
          {
            'currentlyActive': true,
          },
        );
      }
    }

    for (var i = agendaItem.orderIndex + 1;
        i < currentAgendaItems.length;
        i++) {
      batch.update(
        currentAgendaItems[i].reference,
        {
          'orderIndex': FieldValue.increment(-1),
        },
      );
    }

    await batch.commit();
  }

  Future raiseAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    final i = agendaItem.orderIndex;

    if (i == 0) {
      return;
    }

    final batch = _firestore.batch();

    batch.update(
      currentAgendaItems[i - 1].reference,
      {
        'orderIndex': FieldValue.increment(1),
      },
    );
    batch.update(
      currentAgendaItems[i].reference,
      {
        'orderIndex': FieldValue.increment(-1),
      },
    );

    await batch.commit();
  }

  Future lowerAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    final i = agendaItem.orderIndex;

    if (i == currentAgendaItems.length - 1) {
      return;
    }

    final batch = _firestore.batch();

    batch.update(
      currentAgendaItems[i + 1].reference,
      {
        'orderIndex': FieldValue.increment(-1),
      },
    );
    batch.update(
      currentAgendaItems[i].reference,
      {
        'orderIndex': FieldValue.increment(1),
      },
    );

    await batch.commit();
  }

  Future setAgendaItemType(
      AgendaItemModel agendaItem, AgendaItemType type) async {
    switch (type) {
      case AgendaItemType.text:
        await _setAgendaItemToText(agendaItem);
        break;
      case AgendaItemType.knockout:
        await _setAgendaItemToKnockoutRound(agendaItem);
        break;
      case AgendaItemType.notSpecified:
        break;
    }
  }

  Future _setAgendaItemToText(AgendaItemModel agendaItem) async {
    await agendaItem.reference.update({
      'type': AgendaItemType.text.id,
      'title': '',
      'subtitle': '',
    });
  }

  Future _setAgendaItemToKnockoutRound(AgendaItemModel agendaItem) async {
    await agendaItem.reference.update({
      'type': AgendaItemType.knockout.id,
      'integralsCodes': [],
      'spareIntegralsCodes': [],
      'competitor1Name': '',
      'competitor2Name': '',
      'timeLimitPerIntegral': 5 * 60,
      'timeLimitPerSpareIntegral': 5 * 60,
      'scores': agendaItem.currentlyActive ? [] : null,
      'progressIndex': agendaItem.currentlyActive ? 0 : null,
      'phaseIndex': agendaItem.currentlyActive ? 0 : null,
      'timerStopsAt': null,
      'pausedTimerDuration': null,
    });
  }

  Future editAgendaItemText(
    AgendaItemModel agendaItem, {
    required String title,
    required String subtitle,
  }) async {
    await agendaItem.reference.update({
      'title': title,
      'subtitle': subtitle,
    });
  }

  Future editAgendaItemKnockout(
    AgendaItemModel agendaItem, {
    required String integralsCodes,
    required String spareIntegralsCodes,
    required String competitor1Name,
    required String competitor2Name,
    required Duration timeLimitPerIntegral,
    required Duration timeLimitPerSpareIntegral,
  }) async {
    await agendaItem.reference.update({
      'integralsCodes': integralsCodes.split(','),
      'spareIntegralsCodes': spareIntegralsCodes.split(','),
      'competitor1Name': competitor1Name,
      'competitor2Name': competitor2Name,
      'timeLimitPerIntegral': timeLimitPerIntegral.inSeconds,
      'timeLimitPerSpareIntegral': timeLimitPerSpareIntegral.inSeconds,
    });
  }

  void _resetAgendaItem(AgendaItemModel agendaItem, WriteBatch batch) async {
    switch (agendaItem.type) {
      case AgendaItemType.text:
        batch.update(agendaItem.reference, {
          'currentlyActive': false,
          'finished': false,
          'status': '',
        });
      case AgendaItemType.knockout:
        batch.update(agendaItem.reference, {
          'currentlyActive': false,
          'finished': false,
          'status': '',

          'scores': null,
          'progressIndex': null,
          'phaseIndex': null,
          'timerStopsAt': null,
          'pausedTimerDuration': null,
          'currentIntegralCode': null,
        });
        break;
      case AgendaItemType.notSpecified:
        batch.update(agendaItem.reference, {
          'currentlyActive': false,
          'finished': false,
          'status': '',
        });
        break;
    }
  }

  Future _startAgendaItem(AgendaItemModel agendaItem, WriteBatch batch) async {
    switch (agendaItem.type) {
      case AgendaItemType.text:
        batch.update(agendaItem.reference, {
          'currentlyActive': true,
          'finished': true,
          'status': '',
        });
        break;
      case AgendaItemType.knockout:
        batch.update(agendaItem.reference, {
          'currentlyActive': true,
          'finished': false,
          'status': '',

          'scores': [-1],
          'progressIndex': 0,
          'phaseIndex': 0,
          'timerStopsAt': null,
          'pausedTimerDuration': null,
          'currentIntegralCode': agendaItem.integralsCodes?.firstOrNull,
        });
        break;
      case AgendaItemType.notSpecified:
        batch.update(agendaItem.reference, {
          'currentlyActive': true,
          'finished': true,
          'status': '',
        });
        break;
    }
  }

  Future forceStartAgendaItem(AgendaItemModel agendaItem) async {
    final batch = _firestore.batch();

    // Deactivate currently active items:
    final activeItems = await getActiveAgendaItems();
    for (var item in activeItems) {
      _resetAgendaItem(item, batch);
    }

    // Start new item:
    _startAgendaItem(agendaItem, batch);

    await batch.commit();
  }

  Future goBack(AgendaItemModel currentAgendaItem) async {
    final result = await AgendaItemModel.collection
        .where('uid', isEqualTo: uid)
        .where('orderIndex', isEqualTo: currentAgendaItem.orderIndex - 1)
        .limit(1)
        .get();
    final previousAgendaItem = _agendaItemFromFirebase(result.docs.first)!;

    final batch = _firestore.batch();
    _resetAgendaItem(currentAgendaItem, batch);
    _startAgendaItem(previousAgendaItem, batch);
    await batch.commit();
  }

  Future goForward(AgendaItemModel currentAgendaItem) async {
    final result = await AgendaItemModel.collection
        .where('uid', isEqualTo: uid)
        .where('orderIndex', isEqualTo: currentAgendaItem.orderIndex + 1)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      final batch = _firestore.batch();
      _resetAgendaItem(currentAgendaItem, batch);
      final nextAgendaItem = _agendaItemFromFirebase(result.docs.first)!;
      _startAgendaItem(nextAgendaItem, batch);
      await batch.commit();
    }
  }

  // ignore: non_constant_identifier_names
  Future knockoutRound_startIntegral(AgendaItemModel agendaItem) async {
    Duration timeLimit;

    if (agendaItem.progressIndex! < agendaItem.integralsCodes!.length) {
      timeLimit = agendaItem.timeLimitPerIntegral!;
    } else {
      timeLimit = agendaItem.timeLimitPerSpareIntegral!;
    }

    DateTime timerStopsAt = DateTime.now().add(timeLimit);

    await agendaItem.reference.update({
      'phaseIndex': 1,
      'timerStopsAt': timerStopsAt.millisecondsSinceEpoch,
      'pausedTimerDuration': null,
    });
  }

  // ignore: non_constant_identifier_names
  Future knockoutRound_pauseTimer(AgendaItemModel agendaItem) async {
    var pausedTimerDuration =
        agendaItem.timerStopsAt!.difference(DateTime.now());
    if (pausedTimerDuration.isNegative) {
      pausedTimerDuration = Duration.zero;
    }

    await agendaItem.reference.update({
      'pausedTimerDuration': pausedTimerDuration.inSeconds,
    });
  }

  // ignore: non_constant_identifier_names
  Future knockoutRound_resumeTimer(AgendaItemModel agendaItem) async {
    final timerStopsAt = DateTime.now().add(agendaItem.pausedTimerDuration!);

    await agendaItem.reference.update({
      'timerStopsAt': timerStopsAt.millisecondsSinceEpoch,
      'pausedTimerDuration': null,
    });
  }

  // ignore: non_constant_identifier_names
  Future knockoutRound_showSolution(AgendaItemModel agendaItem) async {
    await agendaItem.reference.update({
      'phaseIndex': 2,
      'pausedTimerDuration': null,
      'timerStopsAt': null,
    });
  }

  // ignore: non_constant_identifier_names
  Future knockoutRound_setWinner(AgendaItemModel agendaItem, int winner) async {
    var scores = agendaItem.scores!;
    scores[agendaItem.progressIndex!] = winner;

    final competitor1Score = scores.where((x) => x == 1).length;
    final competitor2Score = scores.where((x) => x == 2).length;
    bool finished = false;
    String status = '';

    if (agendaItem.progressIndex! >= agendaItem.integralsCodes!.length - 1) {
      if(competitor1Score < competitor2Score) {
        finished = true;
        status = '${agendaItem.competitor2Name} wins!';
      } else if(competitor1Score > competitor2Score) {
        finished = true;
        status = '${agendaItem.competitor1Name} wins!';
      }
    }

    await agendaItem.reference.update({
      'finished': finished,
      'status': status,

      'scores': scores,
      'phaseIndex': 3,
      'timerStopsAt': null,
      'pausedTimerDuration': null,
    });
  }

  // ignore: non_constant_identifier_names
  Future<bool> knockoutRound_nextIntegral(AgendaItemModel agendaItem) async {
    final progressIndex = agendaItem.progressIndex!;
    var scores = [...agendaItem.scores!];
    late final String nextIntegralCode;

    if (progressIndex + 1 < agendaItem.integralsCodes!.length) {
      nextIntegralCode = agendaItem.integralsCodes![progressIndex + 1];
    } else {
      // Find unused spare integral:
      final integralsService = IntegralsService(uid: uid);
      final integrals = <IntegralModel>[];

      for (final code in agendaItem.spareIntegralsCodes!) {
        final integral = await integralsService.getIntegral(code: code);
        integrals.add(integral);
      }

      late final IntegralModel integral;
      try {
        integral = integrals.firstWhere(
          (integral) => !integral.alreadyUsedAsSpareIntegral,
        );
      } catch (err) {
        return false;
      }

      // Set integral to used:
      await integralsService.setIntegralToUsed(integral);

      nextIntegralCode = integral.code;
    }

    // Add score element:
    scores.add(-1);

    await agendaItem.reference.update({
      'scores': scores,
      'progressIndex': progressIndex + 1,
      'phaseIndex': 0,
      'timerStopsAt': null,
      'pausedTimerDuration': null,
      'currentIntegralCode': nextIntegralCode,
    });

    return true;
  }
}
