import "dart:io" show File, FileMode;
import "dart:typed_data";

import "package:http/http.dart" as http;
import "package:nyxx/nyxx.dart" show IAttachment;

/// Extensions for downloading attachment
extension DownloadAttachmentExtensions on IAttachment {
  /// Downloads [Attachment] and saves to given [file].
  /// Returns modified file
  Future<File> downloadAsFile(File file) async {
    final dataBytes = await downloadAsBytes();
    return file.writeAsBytes(dataBytes, mode: FileMode.writeOnly);
  }

  /// Downloads attachment as returns bytes of downloaded file.
  Future<Uint8List> downloadAsBytes() async => (await http.get(Uri.parse(url))).bodyBytes;
}
