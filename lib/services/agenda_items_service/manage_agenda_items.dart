part of 'agenda_items_service.dart';

extension ManageAgendaItems on AgendaItemsService {
  void addAgendaItem({
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    await AgendaItemModel.collection.add(AgendaItemModelNotSpecified.getJson(
      uid:  AgendaItemsService()._uid,
      orderIndex: currentAgendaItems.length,
    ));
  }

  bool canDeleteAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) {
    return !agendaItem.currentlyActive;
  }

  Future deleteAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    if (!canDeleteAgendaItem(
      agendaItem,
      currentAgendaItems: currentAgendaItems,
    )) {
      throw Exception();
    }

    final batch =  AgendaItemsService()._firestore.batch();

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

  bool canRaiseAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) {
    return agendaItem.orderIndex > 0 &&
        !agendaItem.activeOrFinished &&
        !currentAgendaItems[agendaItem.orderIndex - 1].activeOrFinished;
  }

  Future<bool> raiseAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    if (!canRaiseAgendaItem(
      agendaItem,
      currentAgendaItems: currentAgendaItems,
    )) {
      throw Exception();
    }

    final i = agendaItem.orderIndex;
    final batch =  AgendaItemsService()._firestore.batch();

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

  bool canLowerAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) {
    return agendaItem.orderIndex < currentAgendaItems.length - 1 &&
        !agendaItem.activeOrFinished &&
        !currentAgendaItems[agendaItem.orderIndex + 1].activeOrFinished;
  }

  Future<bool> lowerAgendaItem(
    AgendaItemModel agendaItem, {
    required List<AgendaItemModel> currentAgendaItems,
  }) async {
    if (!canLowerAgendaItem(
      agendaItem,
      currentAgendaItems: currentAgendaItems,
    )) {
      throw Exception();
    }

    final i = agendaItem.orderIndex;
    final batch =  AgendaItemsService()._firestore.batch();

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
    AgendaItemModelNotSpecified agendaItem,
    AgendaItemType type,
  ) async {
    await agendaItem.reference.update(type.minimalJson);
  }
}
