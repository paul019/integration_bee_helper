import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';

abstract class AgendaItemModel {
  // Static:
  final String? id;
  final String uid;
  final int orderIndex;
  late final AgendaItemType type;
  final bool currentlyActive;
  final bool finished;
  final String status;


  AgendaItemModel({
    this.id,
    required this.uid,
    required this.orderIndex,
    this.currentlyActive = false,
    this.finished = false,
    this.status = '',
  });

  factory AgendaItemModel.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) {
    final AgendaItemType type = AgendaItemType.fromString(json['type']);

    switch (type) {
      case AgendaItemType.notSpecified:
        return AgendaItemModelNotSpecified.fromJson(json, id: id);
      case AgendaItemType.knockout:
        return AgendaItemModelKnockout.fromJson(json, id: id);
      case AgendaItemType.qualification:
        return AgendaItemModelQualification.fromJson(json, id: id);
      case AgendaItemType.text:
        throw AgendaItemModelText.fromJson(json, id: id);
    }
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'orderIndex': orderIndex,
        'type': type.id,
        'currentlyActive': currentlyActive,
      };

  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('agendaItems');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(id!);

  String get displayTitle;
  String get displaySubtitle;
}
