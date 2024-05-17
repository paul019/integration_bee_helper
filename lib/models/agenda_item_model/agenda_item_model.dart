import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_not_specified.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';

abstract class AgendaItemModel {
  // Static:
  final String id;
  final String uid;
  final int orderIndex;
  late final AgendaItemType type;

  // Dynamic:
  final bool currentlyActive;
  final bool finished;
  final String? status;

  AgendaItemModel({
    required this.id,
    required this.uid,
    required this.orderIndex,
    this.currentlyActive = false,
    this.finished = false,
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
    }
  }

  // Firebase:
  static CollectionReference<Map<String, dynamic>> get collection =>
      FirebaseFirestore.instance.collection('agendaItems');
  DocumentReference<Map<String, dynamic>> get reference => collection.doc(id);

  // Getters:
  bool get activeOrFinished => currentlyActive || finished;
  String get displayTitle;
  String get displaySubtitle;

  // Database operations:
  Future<void> editStatic();
  Future<void> checkEdit() async {
    // Make sure, agenda item is not finished:
    if (finished) {
      throw Exception('Cannot edit finished agenda item');
    }
  }

  void reset(WriteBatch batch) {
    batch.update(reference, {
      'currentlyActive': false,
      'finished': false,
      'status': null,
    });
  }

  void start(WriteBatch batch) {
    batch.update(reference, {
      'currentlyActive': true,
      'finished': true,
      'status': null,
    });
  }

  void end(WriteBatch batch) {
    batch.update(reference, {
      'currentlyActive': false,
      'finished': true,
    });
  }
}
