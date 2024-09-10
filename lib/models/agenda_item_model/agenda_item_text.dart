import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_bee_helper/extensions/map_extension.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_phase.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/services/basic_services/storage_service.dart';

class AgendaItemModelText extends AgendaItemModel {
  // Static:
  final String title;
  final String subtitle;
  final String? imagePath;
  final String? imageUrl;

  AgendaItemModelText({
    required super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.phase = AgendaItemPhase.idle,
    super.status = '',
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imageUrl,
  });

  factory AgendaItemModelText.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) =>
      AgendaItemModelText(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        phase: AgendaItemPhase.fromValue(json['phase']),
        status: json['status'],
        title: json['title'],
        subtitle: json['subtitle'],
        imagePath: json['imagePath'],
        imageUrl: json['imageUrl'] == '' ? null : json['imageUrl'],
      );

  static Map<String, dynamic> minimalJson = {
    'type': AgendaItemType.text.id,
    'title': '',
    'subtitle': '',
    'imagePath': null,
    'imageUrl': null,
  };

  // Getters:
  @override
  AgendaItemType get type => AgendaItemType.text;
  bool get hasTitle => title != '' || subtitle != '';
  bool get hasImage => imageUrl != null;

  @override
  String displayTitle(BuildContext context) => title;
  @override
  String displaySubtitle(BuildContext context) =>
      '${MyIntl.of(context).agendaItemNumber(orderIndex + 1)} – ${MyIntl.of(context).text}';

  // Database operations:
  @override
  Future<void> editStatic({
    String? title,
    String? subtitle,
  }) async {
    await checkEdit();

    await reference.update({
      'title': title,
      'subtitle': subtitle,
    }.deleteNullEntries());
  }

  void uploadImage({
    required XFile image,
    required Function(Exception) onError,
  }) {
    StorageService().uploadImage(
      image: image,
      onError: onError,
      onSuccess: (path, url) {
        reference.update({"imagePath": path, "imageUrl": url});
      },
    );
  }

  void deleteImage({
    required String path,
    required Function(Exception) onError,
  }) {
    StorageService().deleteImage(
      path: path,
      onError: onError,
      onSuccess: () {
        reference.update({"imagePath": null, "imageUrl": null});
      },
    );
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
