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

    await batch.commit();
  }
}
