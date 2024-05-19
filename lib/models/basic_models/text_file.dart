import 'package:flutter/material.dart';

class TextFile {
  final String fileName;
  final String content;

  TextFile({
    required this.fileName,
    required this.content,
  });

  static Future<TextFile> fromAsset(
    BuildContext context, {
    required String assetFileName,
    required String displayFileName,
  }) async {
    final content =
        await DefaultAssetBundle.of(context).loadString(assetFileName);

    return TextFile(
      fileName: displayFileName,
      content: content,
    );
  }

  TextFile makeReplacement({
    String oldText = '% PLACEHOLDER',
    required String newText,
  }) {
    return TextFile(
      fileName: fileName,
      content: content.replaceAll(oldText, newText),
    );
  }
}
