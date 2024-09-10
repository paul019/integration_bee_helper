import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_video.dart';
import 'package:integration_bee_helper/services/basic_services/intl_service.dart';
import 'package:integration_bee_helper/widgets/youtube_view.dart';

class PresentationScreenVideo extends StatelessWidget {
  final AgendaItemModelVideo activeAgendaItem;
  final Size size;
  final bool isPreview;

  const PresentationScreenVideo({
    super.key,
    required this.activeAgendaItem,
    required this.size,
    required this.isPreview,
  });

  @override
  Widget build(BuildContext context) {
    final p = size.width / 1920.0;

    if (activeAgendaItem.youtubeVideoId == '') {
      return Container();
    } else if (isPreview) {
      return Text(
        MyIntl.of(context).videoPlaceholder,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 100 * p),
      );
    } else {
      return YoutubeView(
        videoId: activeAgendaItem.youtubeVideoId,
        size: size,
      );
    }
  }
}
