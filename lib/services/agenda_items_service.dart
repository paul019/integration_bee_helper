import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/agenda_item_model.dart';

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

  void addAgendaItem({
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    // Create agenda item:
    final agendaItem = AgendaItemModel(
      uid: uid,
      orderIndex: currentAgendaItems.length,
      currentlyActive: currentAgendaItems.isEmpty,
    );

    // Add integral:
    await _firestore.collection('agendaItems').add(agendaItem.toJson());
  }

  Future deleteAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    final batch = _firestore.batch();

    batch.delete(_firestore.collection('agendaItems').doc(agendaItem.id!));

    for (var i = agendaItem.orderIndex + 1;
        i < currentAgendaItems.length;
        i++) {
      batch.update(
        _firestore.collection('agendaItems').doc(currentAgendaItems[i].id!),
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
      _firestore.collection('agendaItems').doc(currentAgendaItems[i - 1].id!),
      {
        'orderIndex': FieldValue.increment(1),
      },
    );
    batch.update(
      _firestore.collection('agendaItems').doc(currentAgendaItems[i].id!),
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
      _firestore.collection('agendaItems').doc(currentAgendaItems[i + 1].id!),
      {
        'orderIndex': FieldValue.increment(-1),
      },
    );
    batch.update(
      _firestore.collection('agendaItems').doc(currentAgendaItems[i].id!),
      {
        'orderIndex': FieldValue.increment(1),
      },
    );

    if (agendaItem.currentlyActive) {
      batch.update(
        _firestore.collection('agendaItems').doc(currentAgendaItems[i + 1].id!),
        {
          'currentlyActive': true,
        },
      );
      batch.update(
        _firestore.collection('agendaItems').doc(currentAgendaItems[i].id!),
        {
          'currentlyActive': false,
        },
      );
    }

    await batch.commit();
  }

  Future setAgendaItemToText(AgendaItemModel agendaItem) async {
    await _firestore.collection('agendaItems').doc(agendaItem.id!).update({
      'type': AgendaItemType.text.id,
      'text': '',
    });
  }

  Future editAgendaItemText(
    String agendaItemId, {
    required String text,
  }) async {
    await _firestore.collection('agendaItems').doc(agendaItemId).update({
      'text': text,
    });
  }

  Future editAgendaItemKnockout(
    String agendaItemId, {
    required String integralsCodes,
    required String spareIntegralsCodes,
    required String competitor1Name,
    required String competitor2Name,
    required Duration timeLimitPerIntegral,
    required Duration timeLimitPerSpareIntegral,
  }) async {
    await _firestore.collection('agendaItems').doc(agendaItemId).update({
      'integralsCodes': integralsCodes.split(','),
      'spareIntegralsCodes': spareIntegralsCodes.split(','),
      'competitor1Name': competitor1Name,
      'competitor2Name': competitor2Name,
      'timeLimitPerIntegral': timeLimitPerIntegral.inSeconds,
      'timeLimitPerSpareIntegral': timeLimitPerSpareIntegral.inSeconds,
    });
  }

  Future setAgendaItemToKnockoutRound(AgendaItemModel agendaItem) async {
    await _firestore.collection('agendaItems').doc(agendaItem.id!).update({
      'type': AgendaItemType.knockout.id,
      'integralsCodes': [],
      'spareIntegralsCodes': [],
      'competitor1Name': '',
      'competitor2Name': '',
      'timeLimitPerIntegral': 5 * 60,
      'timeLimitPerSpareIntegral': 5 * 60,
      'scores': null,
      'progressIndex': null,
      'phaseIndex': null,
      'lastTimerStartedAt': null,
    });
  }
}
