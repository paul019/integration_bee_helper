part of 'agenda_items_service.dart';

extension ManageAgendaItems on AgendaItemsService {
  void addAgendaItem({
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    await AgendaItemModel.collection.add(AgendaItemModelNotSpecified.getJson(
      uid: uid,
      orderIndex: currentAgendaItems.length,
      currentlyActive: currentAgendaItems.isEmpty,
    ));
  }

  Future deleteAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    final batch = _firestore.batch();

    // Delete agenda item:
    batch.delete(agendaItem.reference);

    // Choose new active agenda item:
    if (agendaItem.currentlyActive) {
      final i = agendaItem.orderIndex;

      if (i + 1 < currentAgendaItems.length) {
        batch.update(
          currentAgendaItems[i + 1].reference,
          {'currentlyActive': true},
        );
      } else if (currentAgendaItems.length >= 2) {
        batch.update(
          currentAgendaItems[currentAgendaItems.length - 2].reference,
          {'currentlyActive': true},
        );
      }
    }

    // Update order indexes:
    for (var i = agendaItem.orderIndex + 1;
        i < currentAgendaItems.length;
        i++) {
      batch.update(
        currentAgendaItems[i].reference,
        {'orderIndex': FieldValue.increment(-1)},
      );
    }

    // Commit changes:
    await batch.commit();
  }

  Future<bool> raiseAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    final i = agendaItem.orderIndex;

    if (i == 0) {
      return false;
    }

    final batch = _firestore.batch();

    batch.update(
      currentAgendaItems[i - 1].reference,
      {'orderIndex': FieldValue.increment(1)},
    );
    batch.update(
      currentAgendaItems[i].reference,
      {'orderIndex': FieldValue.increment(-1)},
    );

    await batch.commit();
    return true;
  }

  Future<bool> lowerAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    final i = agendaItem.orderIndex;

    if (i == currentAgendaItems.length - 1) {
      return false;
    }

    final batch = _firestore.batch();

    batch.update(
      currentAgendaItems[i + 1].reference,
      {'orderIndex': FieldValue.increment(-1)},
    );
    batch.update(
      currentAgendaItems[i].reference,
      {'orderIndex': FieldValue.increment(1)},
    );

    await batch.commit();
    return true;
  }

  Future setAgendaItemType(
    AgendaItemModel agendaItem,
    AgendaItemType type,
  ) async {
    await agendaItem.reference.update(type.minimalJson);
  }
}
