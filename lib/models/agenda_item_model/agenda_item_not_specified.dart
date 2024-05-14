import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';

class AgendaItemModelNotSpecified extends AgendaItemModel {
  AgendaItemModelNotSpecified({
    required super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.finished = false,
    super.status = '',
  }) {
    super.type = AgendaItemType.notSpecified;
  }

  factory AgendaItemModelNotSpecified.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) =>
      AgendaItemModelNotSpecified(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        finished: json['finished'] ?? false,
        status: json['status'] ?? '',
      );

  @override
  String get displayTitle => 'Not specified yet';
  @override
  String get displaySubtitle => 'Agenda item #${orderIndex + 1}';

  static Map<String, dynamic> getJson({
    required String uid,
    required int orderIndex,
  }) =>
      {
        'uid': uid,
        'orderIndex': orderIndex,
        'type': AgendaItemType.notSpecified.id,
        'currentlyActive': false,
      };
}
