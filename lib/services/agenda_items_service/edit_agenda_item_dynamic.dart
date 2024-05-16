part of 'agenda_items_service.dart';

extension EditAgendaItemDynamic on AgendaItemsService {
  Future forceStartAgendaItem(AgendaItemModel agendaItem) async {
    final activeItem = await getActiveAgendaItem();
    final activeItemOrderIndex = activeItem?.orderIndex ?? 0;

    final batch = _firestore.batch();

    // Handle skipped agenda items:
    for (int i = activeItemOrderIndex; i < agendaItem.orderIndex; i++) {
      final skippedAgendaItem = await getAgendaItemFromOrderIndex(i);
      skippedAgendaItem?.end(batch);
    }

    // Activate new item:
    agendaItem.start(batch);

    // Handle backwards skipped agenda items:
    for (int i = agendaItem.orderIndex + 1; i <= activeItemOrderIndex; i++) {
      final skippedAgendaItem = await getAgendaItemFromOrderIndex(i);
      skippedAgendaItem?.reset(batch);
    }

    await batch.commit();
  }

  Future goBack(AgendaItemModel currentAgendaItem) async {
    final previousAgendaItem = await getAgendaItemFromOrderIndex(currentAgendaItem.orderIndex - 1);

    if(previousAgendaItem == null) {
      throw Exception('Cannot go back any further');
    }

    final batch = _firestore.batch();
    currentAgendaItem.reset(batch);
    previousAgendaItem.start(batch);
    await batch.commit();
  }

  Future goForward(AgendaItemModel currentAgendaItem) async {
    final nextAgendaItem = await getAgendaItemFromOrderIndex(currentAgendaItem.orderIndex + 1);

    if(nextAgendaItem == null) {
      throw Exception('Cannot go forward any further');
    }

    final batch = _firestore.batch();
    currentAgendaItem.end(batch);
    nextAgendaItem.start(batch);
    await batch.commit();
  }
}
