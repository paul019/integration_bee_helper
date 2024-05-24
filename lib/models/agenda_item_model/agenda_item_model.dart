import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_video.dart';

abstract class AgendaItemModel {
  // Static:
  final String id;
  final String uid;
  final int orderIndex;

  // Dynamic:
  final bool currentlyActive;
  final AgendaItemPhase phase;
  final String? status;

  AgendaItemModel({
    required this.id,
    required this.uid,
    required this.orderIndex,
    this.currentlyActive = false,
    this.phase = AgendaItemPhase.idle,
    this.status,
  });

  factory AgendaItemModel.fromJson(
    Map<String, dynamic> json, {
    required String id,
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
        return AgendaItemModelText.fromJson(json, id: id);
      case AgendaItemType.video:
        return AgendaItemModelVideo.fromJson(json, id: id);
    }
  }

  // Firebase:
  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('agendaItems');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(id);

  // Getters:
  AgendaItemType get type;
  bool get activeOrOver => phase.activeOrOver;
  String get displayTitle;
  String get displaySubtitle;

  // Database operations:
  Future<void> editStatic();
  Future<void> checkEdit() async {
    // Make sure, agenda item is not finished:
    if (phase == AgendaItemPhase.over) {
      throw Exception('Cannot edit finished agenda item');
    }
  }

  void reset(WriteBatch batch) {
    batch.update(reference, {
      'currentlyActive': false,
      'phase': AgendaItemPhase.idle.value,
      'status': null,
    });
  }

  Future start(WriteBatch batch) async {
    batch.update(reference, {
      'currentlyActive': true,
      'phase': AgendaItemPhase.active.value,
      'status': null,
    });
  }

  void end(WriteBatch batch) {
    batch.update(reference, {
      'currentlyActive': false,
      'phase': AgendaItemPhase.over.value,
    });
  }
}
