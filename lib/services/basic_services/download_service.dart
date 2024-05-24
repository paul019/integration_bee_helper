import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:integration_bee_helper/models/basic_models/text_file.dart';

class DownloadService {
  downloadFilesAsZIP({
    required List<TextFile> files,
    String zipFileName = 'out.zip',
  }) {
    final encoder = ZipEncoder();
    final archive = Archive();

    for (var file in files) {
      final encoded = utf8.encode(file.content);

      final archiveFile = ArchiveFile(
        file.fileName,
        encoded.lengthInBytes,
        encoded,
      );

      archive.addFile(archiveFile);
    }

    final outputStream = OutputStream(
      byteOrder: LITTLE_ENDIAN,
    );
    final bytes = encoder.encode(
      archive,
      level: Deflate.BEST_COMPRESSION,
      output: outputStream,
    );

    downloadFile(
      fileName: zipFileName,
      bytes: Uint8List.fromList(bytes!),
    );
  }

  downloadFile({required String fileName, required Uint8List bytes}) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body?.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
