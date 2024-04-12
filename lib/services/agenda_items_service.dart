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

    // Add integral:
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

  Future setAgendaItemToText(AgendaItemModel agendaItem) async {
    await agendaItem.reference.update({
      'type': AgendaItemType.text.id,
      'title': '',
      'subtitle': '',
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

  Future setAgendaItemToKnockoutRound(AgendaItemModel agendaItem) async {
    await agendaItem.reference.update({
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

  Future resetAgendaItem(AgendaItemModel agendaItem, {WriteBatch? batch}) async {
    final externalBatch = batch != null;
    if(!externalBatch) {
      batch = _firestore.batch();
    }

    switch (agendaItem.type) {
      case AgendaItemType.text:
        break;
      case AgendaItemType.knockout:
        batch.update(agendaItem.reference, {
          'scores': null,
          'progressIndex': null,
          'phaseIndex': null,
          'lastTimerStartedAt': null,
        });
        break;
      case AgendaItemType.notSpecified:
        break;
    }

    if(!externalBatch) {
      await batch.commit();
    }
  }

  Future startAgendaItem(AgendaItemModel agendaItem) async {
    final batch = _firestore.batch();

    // Deactivate currently active items:
    final activeItems = await getActiveAgendaItems();
    for(var item in activeItems) {
      resetAgendaItem(item, batch: batch);
      batch.update(item.reference, {'currentlyActive': false});
    }

    // Reset new item:
    resetAgendaItem(agendaItem, batch: batch);

    // Activate new item:
    await agendaItem.reference.update({
      'currentlyActive': true,
    });
  }
}
