import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/problem_phase.dart';
import 'package:integration_bee_helper/models/basic_models/timer_model.dart';
import 'package:integration_bee_helper/services/integrals_service.dart';

part 'manage_agenda_items.dart';
part 'edit_agenda_item_dynamic.dart';

class AgendaItemsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String get _uid => _firebaseAuth.currentUser!.uid;

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
        .where('uid', isEqualTo: _uid)
        .orderBy('orderIndex')
        .snapshots()
        .map(_agendaItemListFromFirebase);
  }

  Stream<List<AgendaItemModel>> get onActiveAgendaItemChanged {
    return _firestore
        .collection('agendaItems')
        .where('uid', isEqualTo: _uid)
        .where('currentlyActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map(_agendaItemListFromFirebase);
  }

  Future<AgendaItemModel?> getActiveAgendaItem() async {
    final activeItems = await _firestore
        .collection('agendaItems')
        .where('uid', isEqualTo: _uid)
        .where('currentlyActive', isEqualTo: true)
        .limit(1)
        .get();

    return _agendaItemListFromFirebase(activeItems).firstOrNull;
  }

  Future<AgendaItemModel?> getAgendaItemFromOrderIndex(int orderIndex) async {
    final activeItems = await _firestore
        .collection('agendaItems')
        .where('uid', isEqualTo: _uid)
        .where('orderIndex', isEqualTo: orderIndex)
        .limit(1)
        .get();

    return _agendaItemListFromFirebase(activeItems).firstOrNull;
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
      final String? response = await IntegralsService.findUnusedSpareIntegral(
          agendaItem.spareIntegralsCodes!);

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
    final String? response = await IntegralsService.findUnusedSpareIntegral(
        agendaItem.spareIntegralsCodes!);

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
