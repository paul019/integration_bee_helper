import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';

class AgendaItemModelText extends AgendaItemModel {
  // Static:
  final String title;
  final String subtitle;
  final String imageUrl;

  AgendaItemModelText({
    super.id,
    required super.uid,
    required super.orderIndex,
    super.currentlyActive = false,
    super.finished = false,
    super.status = '',
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  }) {
    super.type = AgendaItemType.text;
  }

  factory AgendaItemModelText.fromJson(
    Map<String, dynamic> json, {
    String? id,
  }) =>
      AgendaItemModelText(
        id: id,
        uid: json['uid'],
        orderIndex: json['orderIndex'],
        currentlyActive: json['currentlyActive'],
        finished: json['finished'] ?? false,
        status: json['status'] ?? '',
        title: json['title'],
        subtitle: json['subtitle'],
        imageUrl: json['imageUrl'],
      );

  bool get hasTitle => title != '' || subtitle != '';
  bool get hasImage => imageUrl != '';

  @override
  String get displayTitle => title;
  @override
  String get displaySubtitle => 'Agenda item #${orderIndex + 1} – Text';
}
