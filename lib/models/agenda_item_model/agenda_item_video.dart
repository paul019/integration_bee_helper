import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';

class AgendaItemModelVideo extends AgendaItemModel {
  // Static:
  final String youtubeVideoId;

  AgendaItemModelVideo({
    required super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.phase = AgendaItemPhase.idle,
    super.status = '',
    required this.youtubeVideoId,
  });

  factory AgendaItemModelVideo.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) =>
      AgendaItemModelVideo(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        phase: AgendaItemPhase.fromValue(json['phase']),
        status: json['status'],
        youtubeVideoId: json['youtubeVideoId'],
      );

  static Map<String, dynamic> minimalJson = {
    'type': AgendaItemType.video.id,
    'youtubeVideoId': '',
  };

  // Getters:
  @override
  AgendaItemType get type => AgendaItemType.video;
  bool get fullscreenPresentationView => true;

  @override
  String get displayTitle => 'Video';
  @override
  String get displaySubtitle => 'Agenda item #${orderIndex + 1} – Video';

  // Database operations:
  @override
  Future<void> editStatic({
    String? youtubeVideoId,
  }) async {
    await checkEdit();

    await reference.update({
      'youtubeVideoId': youtubeVideoId,
    }.deleteNullEntries());
  }

  @override
  Future start(WriteBatch batch) async {
    batch.update(reference, {
      'currentlyActive': true,
      'phase': AgendaItemPhase.activeButFinished.value,
      'status': null,
    });
  }
}
