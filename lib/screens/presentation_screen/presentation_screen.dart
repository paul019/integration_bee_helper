import 'package:flutter/material.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_knockout.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_model.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_qualification.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_text.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_type.dart';
import 'package:integration_bee_helper/models/agenda_item_model/agenda_item_video.dart';
import 'package:integration_bee_helper/screens/presentation_screen/background_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/copyright_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/logo_view.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_knockout.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_qualification.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_text.dart';
import 'package:integration_bee_helper/screens/presentation_screen/presentation_screen_video.dart';

class PresentationScreen extends StatefulWidget {
  final AgendaItemModel? activeAgendaItem;
  final Size size;
  final bool isPreview;

  const PresentationScreen({
    super.key,
    required this.activeAgendaItem,
    required this.size,
    this.isPreview = false,
  });

  @override
  State<PresentationScreen> createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  bool transitionMode = false;
  AgendaItemModel? activeAgendaItem;
  String? activeAgendaItemId;

  @override
  Widget build(BuildContext context) {
    if (widget.activeAgendaItem != null) {
      if (widget.activeAgendaItem?.id != activeAgendaItemId &&
          activeAgendaItem != null) {
        doTransition(widget.activeAgendaItem!);
      } else {
        setState(() {
          activeAgendaItem = widget.activeAgendaItem;
        });
      }
      activeAgendaItemId = widget.activeAgendaItem?.id;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        BackgroundView(size: widget.size),
        AnimatedOpacity(
          duration: const Duration(seconds: 2),
          curve: Curves.easeOut,
          opacity: transitionMode ? 0.0 : 1.0,
          child: foreground(),
        ),
        if (!(activeAgendaItem?.fullscreenPresentationView ?? false))
          LogoView(
            size: widget.size,
            transitionMode: transitionMode,
          ),
        if (!(activeAgendaItem?.fullscreenPresentationView ?? false))
          CopyrightView(size: widget.size),
      ],
    );
  }

  Widget foreground() {
    if (activeAgendaItem == null) {
      return Container();
    }

    switch (activeAgendaItem!.type) {
      case AgendaItemType.notSpecified:
        return Container();
      case AgendaItemType.text:
        return PresentationScreenText(
          activeAgendaItem: activeAgendaItem as AgendaItemModelText,
          size: widget.size,
        );
      case AgendaItemType.knockout:
        return PresentationScreenKnockout(
          activeAgendaItem: activeAgendaItem as AgendaItemModelKnockout,
          size: widget.size,
          isPreview: widget.isPreview,
        );
      case AgendaItemType.qualification:
        return PresentationScreenQualification(
          activeAgendaItem: activeAgendaItem as AgendaItemModelQualification,
          size: widget.size,
          isPreview: widget.isPreview,
        );
      case AgendaItemType.video:
        return PresentationScreenVideo(
          activeAgendaItem: activeAgendaItem as AgendaItemModelVideo,
          size: widget.size,
          isPreview: widget.isPreview,
        );
    }
  }

  void doTransition(AgendaItemModel activeAgendaItem) async {
    setState(() {
      transitionMode = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        transitionMode = false;
        this.activeAgendaItem = activeAgendaItem;
      });
    });
  }
}
