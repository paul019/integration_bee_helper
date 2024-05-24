import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'dart:ui_web';

class YoutubeView extends StatelessWidget {
  final Size size;
  final String videoId;

  const YoutubeView({
    super.key,
    required this.size,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context) {
    final viewID = hashCode.toString();

    // ignore: undefined_prefixed_name
    platformViewRegistry.registerViewFactory(
      viewID,
      (int id) => html.IFrameElement()
        ..width = MediaQuery.of(context).size.width.toString()
        ..height = MediaQuery.of(context).size.height.toString()
        ..src = 'https://www.youtube.com/embed/$videoId'
        ..style.border = 'none',
    );

    return SizedBox(
      height: size.height,
      width: size.width,
      child: HtmlElementView(
        viewType: viewID,
      ),
    );
  }
}
