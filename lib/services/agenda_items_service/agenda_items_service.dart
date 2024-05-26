import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integration_bee_helper/models/agenda_item_model/active_agenda_item_wrapper.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model_competition.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/services/integrals_service/integrals_service.dart';

part 'manage_agenda_items.dart';
part 'manage_agenda_items_dynamic.dart';

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

  Stream<ActiveAgendaItemWrapper> get onActiveAgendaItemChanged {
    return _firestore
        .collection('agendaItems')
        .where('uid', isEqualTo: _uid)
        .where('currentlyActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map(
          (res) =>
              res.docs.isEmpty ? null : _agendaItemFromFirebase(res.docs.first),
        )
        .map((item) => ActiveAgendaItemWrapper(item));
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

  Future<AgendaItemModel?> getAgendaItemByIntegralCode(
      String integralCode) async {
    final response1 = await AgendaItemModel.collection
        .where('uid', isEqualTo: _uid)
        .where('integralsCodes', arrayContains: integralCode)
        .get();

    if (response1.docs.isNotEmpty) {
      return _agendaItemFromFirebase(response1.docs.first);
    }

    final response2 = await AgendaItemModel.collection
        .where('uid', isEqualTo: _uid)
        .where('spareIntegralsCodes', arrayContains: integralCode)
        .get();

    if (response2.docs.isNotEmpty) {
      return _agendaItemFromFirebase(response2.docs.first);
    }

    return null;
  }

  Future<List<AgendaItemModelCompetition>> getCompetitionAgendaItems() async {
    final response = await AgendaItemModel.collection
        .where('uid', isEqualTo: _uid)
        .where('type', whereIn: [
      AgendaItemType.qualification.id,
      AgendaItemType.knockout.id,
      AgendaItemType.test.id,
    ]).get();

    return _agendaItemListFromFirebase(response)
        .whereType<AgendaItemModelCompetition>()
        .toList();
  }
}
