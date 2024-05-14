import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';

part 'manage_agenda_items.dart';
part 'edit_agenda_item_static.dart';
part 'edit_agenda_item_dynamic.dart';

class AgendaItemsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid;
  IntegralsService get integralsService => IntegralsService(uid: uid);

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
      case AgendaItemType.qualification:
        batch.update(agendaItem.reference, {
          'currentlyActive': false,
          'finished': false,
          'status': '',
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
      case AgendaItemType.qualification:
        batch.update(agendaItem.reference, {
          'currentlyActive': true,
          'finished': false,
          'status': '',
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
      if (competitor1Score < competitor2Score) {
        finished = true;
        status = '${agendaItem.competitor2Name} wins!';
      } else if (competitor1Score > competitor2Score) {
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
      final String? response = await integralsService
          .findUnusedSpareIntegral(agendaItem.spareIntegralsCodes!);

      if (response == null) {
        return false;
      }

      nextIntegralCode = response;
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

  // ignore: non_constant_identifier_names
  Future qualificationRound_showSolution(AgendaItemModel agendaItem) async {
    await agendaItem.reference.update({
      'phaseIndex': 3,
      'pausedTimerDuration': null,
      'timerStopsAt': null,
    });
  }

  // ignore: non_constant_identifier_names
  Future<bool> qualificationRound_nextIntegral(
      AgendaItemModel agendaItem) async {
    final progressIndex = agendaItem.progressIndex!;
    late final String nextIntegralCode;

    // Find unused spare integral:
    final integralsService = IntegralsService(uid: uid);
    final String? response = await integralsService
        .findUnusedSpareIntegral(agendaItem.spareIntegralsCodes!);

    if (response == null) {
      return false;
    }

    nextIntegralCode = response;

    await agendaItem.reference.update({
      'progressIndex': progressIndex + 1,
      'phaseIndex': 0,
      'timerStopsAt': null,
      'pausedTimerDuration': null,
      'currentIntegralCode': nextIntegralCode,
    });

    return true;
  }

  // ignore: non_constant_identifier_names
  Future qualificationRound_finish(AgendaItemModel agendaItem) async {
    await agendaItem.reference.update({
      'phaseIndex': 3,
      'finished': true,
      'status': 'Qualification round finished!',
    });
  }
}
