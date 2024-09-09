import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';

class AgendaItemModelNotSpecified extends AgendaItemModel {
  AgendaItemModelNotSpecified({
    required super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.phase = AgendaItemPhase.idle,
    super.status = '',
  });

  factory AgendaItemModelNotSpecified.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) =>
      AgendaItemModelNotSpecified(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        phase: AgendaItemPhase.fromValue(json['phase']),
        status: json['status'],
      );

  static Map<String, dynamic> getJson({
    required String uid,
    required int orderIndex,
  }) =>
      {
        'uid': uid,
        'orderIndex': orderIndex,
        'type': AgendaItemType.notSpecified.id,
        'currentlyActive': false,
        'phase': AgendaItemPhase.idle.value,
        'status': null,
      };

  // Getters:
  @override
  AgendaItemType get type => AgendaItemType.notSpecified;
  @override
  String displayTitle(BuildContext context) => MyIntl.of(context).notSpecified;
  @override
  String displaySubtitle(BuildContext context) => MyIntl.of(context).agendaItemNumber(orderIndex + 1);

  // Database operations:
  @override
  Future<void> editStatic() async {}

  @override
  Future start(WriteBatch batch) async {
    batch.update(reference, {
      'currentlyActive': true,
      'phase': AgendaItemPhase.activeButFinished.value,
      'status': null,
    });
  }
}
